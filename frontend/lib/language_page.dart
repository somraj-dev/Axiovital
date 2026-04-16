import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  final List<Map<String, String>> languages = const [
    {'title': 'English (United States)', 'subtitle': 'English (United States)'},
    {'title': 'Cestina', 'subtitle': 'Czech'},
    {'title': 'Dansk', 'subtitle': 'Danish'},
    {'title': 'Nederlands (Belgie)', 'subtitle': 'Dutch (Belgium)'},
    {'title': 'Nederlands (Nederland)', 'subtitle': 'Dutch (The Netherlands)'},
    {'title': 'English (Australia)', 'subtitle': 'English (Australia)'},
    {'title': 'English (United Kingdom)', 'subtitle': 'English (United Kingdom)'},
    {'title': 'Suomi', 'subtitle': 'Finnish'},
    {'title': 'Hindi', 'subtitle': 'हिन्दी'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final String currentLanguage = userProvider.language;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface, size: 28),
        ),
        title: Text(
          userProvider.translate('language'),
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: languages.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: theme.dividerColor.withOpacity(0.1),
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final lang = languages[index];
                final isSelected = currentLanguage == lang['title'];

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text(
                    lang['title']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface.withOpacity(isSelected ? 1.0 : 0.8),
                    ),
                  ),
                  subtitle: Text(
                    lang['subtitle']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  trailing: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? theme.primaryColor : theme.colorScheme.outline.withOpacity(0.3),
                        width: isSelected ? 7 : 1,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                  onTap: () {
                    userProvider.updateLanguage(lang['title']!);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
