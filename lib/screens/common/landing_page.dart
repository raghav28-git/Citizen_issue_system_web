import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _howItWorksKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 600 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 600 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToHowItWorks() {
    Scrollable.ensureVisible(
      _howItWorksKey.currentContext!,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToAbout() {
    Scrollable.ensureVisible(
      _aboutKey.currentContext!,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(height: _isScrolled ? 70 : 80),
                _buildHeroSection(context),
                _buildFeaturesSection(),
                _buildAboutSection(),
                _buildHowItWorksSection(),
                _buildStatsSection(),
                _buildFooter(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildNavBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: _isScrolled ? 12 : 20),
      decoration: BoxDecoration(
        color: _isScrolled ? Colors.white : Color(0xFF1E293B),
        boxShadow: _isScrolled ? [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: Offset(0, 2)),
        ] : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  'assets/splash/logo.png',
                  height: 40,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'CityCare',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _isScrolled ? Color(0xFF0F172A) : Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildNavItem('Home', _scrollToTop),
              SizedBox(width: 48),
              _buildNavItem('About', _scrollToAbout),
              SizedBox(width: 48),
              _buildNavItem('How it Works', _scrollToHowItWorks),
            ],
          ),
          Row(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFEFF6FF),
                      border: Border.all(color: Color(0xFF93C5FD), width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Log In',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 12, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, VoidCallback? onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: _isScrolled ? Color(0xFF475569) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
      ),
      constraints: BoxConstraints(minHeight: 600),
      padding: EdgeInsets.symmetric(vertical: 120, horizontal: 80),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white, Color(0xFF94A3B8)],
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
                    color: Color(0xFF94A3B8),
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
        color: Color(0xFF1E293B),
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
      key: _howItWorksKey,
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: 80),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
      ),
      child: Column(
        children: [
          Text(
            'How It Works',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
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

  Widget _buildAboutSection() {
    return Container(
      key: _aboutKey,
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: 80),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
      ),
      child: Column(
        children: [
          Text(
            'About CityCare',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1),
          ),
          SizedBox(height: 32),
          Container(
            constraints: BoxConstraints(maxWidth: 800),
            child: Text(
              'CityCare is a revolutionary platform that bridges the gap between citizens and local authorities. We empower communities to report civic issues quickly and efficiently, ensuring that every voice is heard and every problem gets the attention it deserves.',
              style: TextStyle(fontSize: 20, color: Color(0xFF94A3B8), height: 1.8),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAboutCard(Icons.speed_rounded, 'Fast Response', 'Issues resolved within 48 hours on average'),
              SizedBox(width: 32),
              _buildAboutCard(Icons.verified_user_rounded, 'Verified Updates', 'Real-time tracking with official confirmations'),
              SizedBox(width: 32),
              _buildAboutCard(Icons.people_rounded, 'Community Driven', 'Powered by active citizen participation'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(IconData icon, String title, String description) {
    return Container(
      width: 280,
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.white),
          SizedBox(height: 20),
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
          SizedBox(height: 12),
          Text(description, style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
      ),
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
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF334155)),
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
          Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
          SizedBox(height: 12),
          Text(description, style: TextStyle(fontSize: 15, color: Color(0xFF94A3B8)), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String title, String description, IconData icon, List<Color> colors) {
    return Container(
      width: 280,
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF334155)),
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
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
          SizedBox(height: 12),
          Text(description, style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)), textAlign: TextAlign.center),
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
        Text(label, style: TextStyle(fontSize: 18, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
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
