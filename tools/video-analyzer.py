#!/usr/bin/env python3
"""
Video Analysis Tool for Pine Script Visualizer
Extracts and analyzes trading strategy/indicator information from YouTube videos
"""

import os
import re
import json
from typing import Dict, List, Optional
import subprocess
import sys

# Check and install required packages
required_packages = ['youtube-transcript-api', 'pytube', 'openai']

def install_packages():
    """Install required packages if not present"""
    for package in required_packages:
        try:
            __import__(package.replace('-', '_'))
        except ImportError:
            print(f"Installing {package}...")
            subprocess.check_call([sys.executable, "-m", "pip", "install", package])

# Install packages if needed
install_packages()

from youtube_transcript_api import YouTubeTranscriptApi
from pytube import YouTube
import hashlib

class VideoAnalyzer:
    """Analyzes YouTube videos for trading strategy content"""
    
    def __init__(self):
        self.trading_keywords = {
            'indicators': [
                'rsi', 'macd', 'moving average', 'ema', 'sma', 'bollinger bands',
                'stochastic', 'volume', 'atr', 'adx', 'ichimoku', 'fibonacci',
                'pivot points', 'support resistance', 'vwap', 'momentum'
            ],
            'patterns': [
                'breakout', 'trend', 'reversal', 'divergence', 'convergence',
                'cross', 'crossover', 'golden cross', 'death cross', 'squeeze',
                'flag', 'pennant', 'triangle', 'head and shoulders', 'double top',
                'double bottom', 'cup and handle'
            ],
            'strategies': [
                'scalping', 'day trading', 'swing trading', 'position trading',
                'mean reversion', 'trend following', 'momentum', 'arbitrage',
                'pairs trading', 'grid trading', 'martingale', 'dca'
            ],
            'conditions': [
                'entry', 'exit', 'stop loss', 'take profit', 'risk management',
                'position sizing', 'trailing stop', 'break even', 'signal',
                'confirmation', 'filter', 'trigger'
            ],
            'timeframes': [
                '1 minute', '5 minute', '15 minute', '30 minute', '1 hour',
                '4 hour', 'daily', 'weekly', 'monthly', 'multi timeframe',
                'higher timeframe', 'lower timeframe'
            ]
        }
    
    def extract_video_id(self, url: str) -> Optional[str]:
        """Extract YouTube video ID from URL"""
        patterns = [
            r'(?:youtube\.com\/watch\?v=)([\w-]+)',
            r'(?:youtu\.be\/)([\w-]+)',
            r'(?:youtube\.com\/embed\/)([\w-]+)',
            r'(?:youtube\.com\/v\/)([\w-]+)'
        ]
        
        for pattern in patterns:
            match = re.search(pattern, url)
            if match:
                return match.group(1)
        return None
    
    def get_video_metadata(self, url: str) -> Dict:
        """Get video metadata"""
        try:
            yt = YouTube(url)
            return {
                'title': yt.title,
                'author': yt.author,
                'length': yt.length,
                'description': yt.description[:500],  # First 500 chars
                'publish_date': str(yt.publish_date),
                'views': yt.views
            }
        except Exception as e:
            return {'error': str(e)}
    
    def get_transcript(self, video_id: str) -> Optional[str]:
        """Get video transcript"""
        try:
            transcript_list = YouTubeTranscriptApi.get_transcript(video_id)
            transcript = ' '.join([item['text'] for item in transcript_list])
            return transcript
        except Exception as e:
            print(f"Error getting transcript: {e}")
            return None
    
    def extract_key_concepts(self, text: str) -> Dict:
        """Extract trading concepts from text"""
        text_lower = text.lower()
        found_concepts = {
            'indicators': [],
            'patterns': [],
            'strategies': [],
            'conditions': [],
            'timeframes': [],
            'specific_values': []
        }
        
        # Find mentioned concepts
        for category, keywords in self.trading_keywords.items():
            for keyword in keywords:
                if keyword in text_lower:
                    found_concepts[category].append(keyword)
        
        # Extract specific numeric values
        number_patterns = [
            (r'(\d+)\s*(?:period|length|bar|candle)', 'periods'),
            (r'(\d+\.?\d*)\s*(?:%|percent)', 'percentages'),
            (r'(\d+)\s*(?:pip|point)', 'pips'),
            (r'(?:level|zone|area)\s*(?:at|around)?\s*(\d+\.?\d*)', 'levels')
        ]
        
        for pattern, value_type in number_patterns:
            matches = re.findall(pattern, text_lower)
            if matches:
                found_concepts['specific_values'].append({
                    'type': value_type,
                    'values': list(set(matches))[:5]  # Limit to 5 unique values
                })
        
        return found_concepts
    
    def identify_strategy_components(self, text: str) -> Dict:
        """Identify specific strategy components"""
        components = {
            'entry_conditions': [],
            'exit_conditions': [],
            'risk_management': [],
            'indicators_used': [],
            'timeframe': None,
            'market_conditions': []
        }
        
        # Split into sentences for analysis
        sentences = text.split('.')
        
        for sentence in sentences:
            sentence_lower = sentence.lower()
            
            # Entry conditions
            if any(word in sentence_lower for word in ['enter', 'buy', 'long', 'entry signal']):
                components['entry_conditions'].append(sentence.strip())
            
            # Exit conditions
            if any(word in sentence_lower for word in ['exit', 'sell', 'close', 'take profit', 'stop loss']):
                components['exit_conditions'].append(sentence.strip())
            
            # Risk management
            if any(word in sentence_lower for word in ['risk', 'position size', 'money management', 'drawdown']):
                components['risk_management'].append(sentence.strip())
            
            # Market conditions
            if any(word in sentence_lower for word in ['trend', 'ranging', 'volatile', 'breakout']):
                components['market_conditions'].append(sentence.strip())
        
        # Limit entries to most relevant
        for key in components:
            if isinstance(components[key], list) and len(components[key]) > 3:
                components[key] = components[key][:3]
        
        return components
    
    def generate_pine_script_spec(self, concepts: Dict, components: Dict, metadata: Dict) -> Dict:
        """Generate Pine Script specification from analysis"""
        spec = {
            'video_source': {
                'title': metadata.get('title', 'Unknown'),
                'author': metadata.get('author', 'Unknown'),
                'url': metadata.get('url', '')
            },
            'detected_type': self._determine_script_type(concepts, components),
            'main_indicators': list(set(concepts.get('indicators', [])))[:5],
            'trading_patterns': list(set(concepts.get('patterns', [])))[:3],
            'strategy_type': concepts.get('strategies', ['custom'])[0] if concepts.get('strategies') else 'custom',
            'timeframes': concepts.get('timeframes', ['not specified']),
            'implementation_requirements': {
                'entry_logic': self._summarize_conditions(components.get('entry_conditions', [])),
                'exit_logic': self._summarize_conditions(components.get('exit_conditions', [])),
                'risk_rules': self._summarize_conditions(components.get('risk_management', [])),
                'market_filter': components.get('market_conditions', [])[:2]
            },
            'specific_parameters': concepts.get('specific_values', []),
            'complexity_score': self._calculate_complexity(concepts, components),
            'feasibility': self._assess_feasibility(concepts, components)
        }
        
        return spec
    
    def _determine_script_type(self, concepts: Dict, components: Dict) -> str:
        """Determine if indicator or strategy"""
        strategy_indicators = len(components.get('entry_conditions', [])) + len(components.get('exit_conditions', []))
        if strategy_indicators > 2:
            return 'strategy'
        elif concepts.get('indicators'):
            return 'indicator'
        else:
            return 'unknown'
    
    def _summarize_conditions(self, conditions: List[str]) -> List[str]:
        """Summarize condition statements"""
        if not conditions:
            return []
        
        # Extract key phrases
        summaries = []
        for condition in conditions[:3]:  # Limit to 3
            # Remove common words and extract key terms
            key_terms = []
            for word in condition.split():
                if len(word) > 4 and word.lower() not in ['when', 'then', 'that', 'this', 'with']:
                    key_terms.append(word)
            if key_terms:
                summaries.append(' '.join(key_terms[:5]))
        
        return summaries
    
    def _calculate_complexity(self, concepts: Dict, components: Dict) -> int:
        """Calculate complexity score 1-10"""
        score = 1
        
        # Add points for various factors
        score += min(len(concepts.get('indicators', [])), 3)
        score += min(len(concepts.get('patterns', [])), 2)
        score += 1 if components.get('entry_conditions') else 0
        score += 1 if components.get('exit_conditions') else 0
        score += 1 if components.get('risk_management') else 0
        score += 1 if len(concepts.get('timeframes', [])) > 1 else 0
        
        return min(score, 10)
    
    def _assess_feasibility(self, concepts: Dict, components: Dict) -> Dict:
        """Assess Pine Script feasibility"""
        return {
            'overall': 'full' if self._calculate_complexity(concepts, components) <= 7 else 'partial',
            'notes': [],
            'limitations': []
        }
    
    def analyze_video(self, url: str) -> Dict:
        """Main analysis function"""
        video_id = self.extract_video_id(url)
        if not video_id:
            return {'error': 'Invalid YouTube URL'}
        
        # Get metadata
        metadata = self.get_video_metadata(url)
        metadata['url'] = url
        
        # Get transcript
        transcript = self.get_transcript(video_id)
        if not transcript:
            return {
                'error': 'Could not extract transcript',
                'metadata': metadata
            }
        
        # Analyze content
        concepts = self.extract_key_concepts(transcript)
        components = self.identify_strategy_components(transcript)
        
        # Generate specification
        spec = self.generate_pine_script_spec(concepts, components, metadata)
        
        # Create summary
        summary = self.create_user_summary(spec)
        
        return {
            'success': True,
            'summary': summary,
            'detailed_spec': spec,
            'raw_concepts': concepts,
            'raw_components': components,
            'transcript_length': len(transcript),
            'analysis_id': hashlib.md5(video_id.encode()).hexdigest()[:8]
        }
    
    def create_user_summary(self, spec: Dict) -> str:
        """Create user-friendly summary"""
        summary = f"""
📹 VIDEO ANALYSIS COMPLETE
========================

**Source**: {spec['video_source']['title']}
**Author**: {spec['video_source']['author']}

**Detected Type**: {spec['detected_type'].upper()}
**Complexity**: {spec['complexity_score']}/10
**Strategy Style**: {spec['strategy_type']}

**Main Components Identified**:
• Indicators: {', '.join(spec['main_indicators']) if spec['main_indicators'] else 'None specific'}
• Patterns: {', '.join(spec['trading_patterns']) if spec['trading_patterns'] else 'None specific'}
• Timeframes: {', '.join(spec['timeframes'])}

**Trading Logic**:
• Entry: {len(spec['implementation_requirements']['entry_logic'])} conditions found
• Exit: {len(spec['implementation_requirements']['exit_logic'])} conditions found
• Risk: {len(spec['implementation_requirements']['risk_rules'])} rules found

**Feasibility**: {spec['feasibility']['overall'].upper()}

Is this understanding correct? Reply 'yes' to proceed or describe what needs adjustment.
"""
        return summary
    
    def save_analysis(self, analysis: Dict, filename: str = None) -> str:
        """Save analysis to file"""
        if not filename:
            filename = f"video_analysis_{analysis.get('analysis_id', 'unknown')}.json"
        
        filepath = os.path.join('projects', 'analysis', filename)
        os.makedirs(os.path.dirname(filepath), exist_ok=True)
        
        with open(filepath, 'w') as f:
            json.dump(analysis, f, indent=2)
        
        return filepath


def main():
    """Main function for CLI usage"""
    if len(sys.argv) < 2:
        print("Usage: python video-analyzer.py <youtube_url>")
        sys.exit(1)
    
    url = sys.argv[1]
    analyzer = VideoAnalyzer()
    
    print("🎥 Analyzing video...")
    result = analyzer.analyze_video(url)
    
    if result.get('success'):
        print(result['summary'])
        
        # Save analysis
        filepath = analyzer.save_analysis(result)
        print(f"\n📁 Full analysis saved to: {filepath}")
    else:
        print(f"❌ Error: {result.get('error')}")


if __name__ == "__main__":
    main()