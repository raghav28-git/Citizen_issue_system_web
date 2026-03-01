import 'package:flutter/material.dart';
import 'dart:ui';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFEEF2FF), Color(0xFFF1F5F9)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildNavBar(context),
              _buildHeroSection(context),
              _buildFeaturesSection(),
              _buildHowItWorksSection(),
              _buildStatsSection(),
              _buildCTASection(context),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.85)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 12, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Icon(Icons.location_city, color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 16),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Color(0xFF1E293B), Color(0xFF4F46E5)],
                    ).createShader(bounds),
                    child: Text(
                      'CityCare',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildNavItem('Home'),
                  SizedBox(width: 40),
                  _buildNavItem('About'),
                  SizedBox(width: 40),
                  _buildNavItem('How it Works'),
                  SizedBox(width: 40),
                  _buildNavItem('Contact'),
                  SizedBox(width: 40),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 12, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Text(
                          'Login / Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String title) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF475569),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 600),
      padding: EdgeInsets.symmetric(vertical: 120, horizontal: 80),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF4F46E5).withOpacity(0.1), Color(0xFF6366F1).withOpacity(0.1)]),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF4F46E5).withOpacity(0.3)),
                  ),
                  child: Text(
                    '🏙️ Smart Civic Reporting Platform',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF4F46E5)],
                  ).createShader(bounds),
                  child: Text(
                    'Report City Issues\nMake Your City Better',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -2,
                      height: 1.1,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Join thousands of citizens helping improve urban infrastructure.\nReport issues, track progress, and see real change in your community.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 48),
                Row(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/login'),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.4), blurRadius: 20, offset: Offset(0, 8)),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xFFE2E8F0), width: 2),
                        ),
                        child: Text(
                          'Learn More',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 80),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'assets/splash/image1.jpg',
                height: 500,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Why Choose CityCare?',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Everything you need to report and track civic issues',
            style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.9)),
          ),
          SizedBox(height: 64),
          Row(
            children: [
              Expanded(child: _buildFeatureCard(Icons.speed_rounded, 'Fast Reporting', 'Report issues in under 2 minutes', [Color(0xFF4F46E5), Color(0xFF6366F1)])),
              SizedBox(width: 24),
              Expanded(child: _buildFeatureCard(Icons.track_changes_rounded, 'Real-time Tracking', 'Track your reports from start to finish', [Color(0xFF8B5CF6), Color(0xFFA78BFA)])),
              SizedBox(width: 24),
              Expanded(child: _buildFeatureCard(Icons.verified_rounded, 'Verified Updates', 'Get official updates from authorities', [Color(0xFF10B981), Color(0xFF34D399)])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8FAFC), Color(0xFFEEF2FF)],
        ),
      ),
      child: Column(
        children: [
          Text(
            'How It Works',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: 64),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStep('1', 'Report Issue', 'Submit details with photos and location', Icons.report_rounded, [Color(0xFF4F46E5), Color(0xFF6366F1)]),
              SizedBox(width: 60),
              Icon(Icons.arrow_forward_rounded, size: 40, color: Color(0xFFCBD5E1)),
              SizedBox(width: 60),
              _buildStep('2', 'Track Progress', 'Monitor status updates in real-time', Icons.track_changes_rounded, [Color(0xFF8B5CF6), Color(0xFFA78BFA)]),
              SizedBox(width: 60),
              Icon(Icons.arrow_forward_rounded, size: 40, color: Color(0xFFCBD5E1)),
              SizedBox(width: 60),
              _buildStep('3', 'Issue Resolved', 'Get notified when fixed', Icons.check_circle_rounded, [Color(0xFF10B981), Color(0xFF34D399)]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('10K+', 'Issues Reported'),
          _buildStatItem('8.5K+', 'Issues Resolved'),
          _buildStatItem('5K+', 'Active Users'),
          _buildStatItem('95%', 'Satisfaction Rate'),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 80, vertical: 60),
      padding: EdgeInsets.all(80),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 30, offset: Offset(0, 15)),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Ready to Make a Difference?',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Join our community and help improve your city today',
            style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.9)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/login'),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: Offset(0, 8)),
                  ],
                ),
                child: Text(
                  'Start Reporting Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(60),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_city, color: Colors.white, size: 32),
                      SizedBox(width: 12),
                      Text('CityCare', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Making cities better, one report at a time.', style: TextStyle(color: Colors.white70)),
                ],
              ),
              _buildFooterColumn('Product', ['Features', 'How it Works', 'Pricing', 'FAQ']),
              _buildFooterColumn('Company', ['About Us', 'Careers', 'Contact', 'Blog']),
              _buildFooterColumn('Legal', ['Privacy Policy', 'Terms of Service', 'Cookie Policy']),
            ],
          ),
          SizedBox(height: 40),
          Divider(color: Colors.white24),
          SizedBox(height: 20),
          Text('© 2024 CityCare. All rights reserved.', style: TextStyle(color: Colors.white60)),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description, List<Color> colors) {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: colors[0].withOpacity(0.1), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 40, color: Colors.white),
          ),
          SizedBox(height: 24),
          Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
          SizedBox(height: 12),
          Text(description, style: TextStyle(fontSize: 15, color: Color(0xFF64748B)), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String title, String description, IconData icon, List<Color> colors) {
    return Container(
      width: 280,
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: colors[0].withOpacity(0.1), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
          SizedBox(height: 12),
          Text(description, style: TextStyle(fontSize: 14, color: Color(0xFF64748B)), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
          ).createShader(bounds),
          child: Text(
            value,
            style: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 18, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildFooterColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        SizedBox(height: 16),
        ...items.map((item) => Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(item, style: TextStyle(color: Colors.white70)),
        )),
      ],
    );
  }
}
