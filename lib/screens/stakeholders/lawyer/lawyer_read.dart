import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<Map<String, String>> articles = [];

  bool showDropDown = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://www.livelaw.in/'));
    if (response.statusCode == 200) {
      final htmlContent = response.body;
      setState(() {
        articles = extractArticles(htmlContent);
      });
    }
  }

  List<Map<String, String>> extractArticles(String htmlContent) {
    final document = parse(htmlContent);
    List<Map<String, String>> articlesList = [];

    final highlightLink = document.querySelector(
        '#level_1 > div > div > div.col-xs-12.col-sm-12.col-md-4.homepage_col11 > div > a');
    final highlightTitle = document.querySelector(
        '#level_1 > div > div > div.col-xs-12.col-sm-12.col-md-4.homepage_col11 > div > a > div.col-xs-12.col-sm-7.col-md-12.tab_left > h1');
    final highlightImage = document.querySelector(
        '#level_1 > div > div > div.col-xs-12.col-sm-12.col-md-4.homepage_col11 > div > a > div.col-xs-12.col-sm-5.col-md-12 > div > img');

    final otherArticles = extractOtherArticles(document);

    String? imageUrl;

    if (highlightImage != null) {
      imageUrl = highlightImage.attributes['data-src'] ?? '';
      if (!imageUrl.startsWith('http') && !imageUrl.startsWith('https')) {
        imageUrl = 'https://www.livelaw.in$imageUrl';
      }
    }

    String? linkUrl;

    if (highlightLink != null) {
      linkUrl =
          'https://www.livelaw.in' + (highlightLink.attributes['href'] ?? '');
    }

    if (highlightLink != null &&
        highlightTitle != null &&
        highlightImage != null) {
      articlesList.add({
        'title': highlightTitle.text,
        'link': linkUrl ?? '',
        'imageSrc': imageUrl ?? '',
      });
    }

    articlesList.addAll(otherArticles);

    return articlesList;
  }

  List<Map<String, String>> extractOtherArticles(document) {
    List<Map<String, String>> otherArticlesList = [];

    for (int i = 1; i <= 9; i++) {
      final otherLink = document.querySelector(
          '#level_4 > div.container.homepage_supreme_court_cntr3 > div > div:nth-child($i) > a');
      final otherTitle = document.querySelector(
          '#level_4 > div.container.homepage_supreme_court_cntr3 > div > div:nth-child($i) > a > div > div.col-xs-7.col-sm-7.col-md-7 > h6');
      final otherImage = document.querySelector(
          '#level_4 > div.container.homepage_supreme_court_cntr3 > div > div:nth-child($i) > a > div > div.col-xs-5.col-sm-5.col-md-5 > div > img');

      if (otherLink != null && otherTitle != null && otherImage != null) {
        String? otherImageUrl = otherImage.attributes['data-src'] ?? '';
        if (!otherImageUrl!.startsWith('http') &&
            !otherImageUrl.startsWith('https')) {
          otherImageUrl = 'https://www.livelaw.in$otherImageUrl';
        }

        String? otherLinkUrl =
            'https://www.livelaw.in' + (otherLink.attributes['href'] ?? '');

        otherArticlesList.add({
          'title': otherTitle.text,
          'link': otherLinkUrl,
          'imageSrc': otherImageUrl,
        });
      }
    }

    return otherArticlesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal News', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black38,
      ),
      backgroundColor: Colors.black38,
      body: ListView(
        children: [
          if (articles.isNotEmpty)
            InkWell(
              onTap: () => launchUrl(Uri.parse(articles[0]['link']!)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        articles[0]['imageSrc']!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      articles[0]['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // High Court Articles Section
          if (articles.length > 1)
            Column(
              children: [
                // Display the first two high court articles
                for (var article in articles.sublist(1, 3))
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () => launchUrl(Uri.parse(article['link']!)),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                article['imageSrc']!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    article['title']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Show More Articles Button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[900])),
                    onPressed: () {
                      setState(() {
                        showDropDown = !showDropDown;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(showDropDown
                            ? "Hide Articles"
                            : "Show More Articles"),
                        Icon(
                          showDropDown
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          // Dropdown Articles (Hidden by Default)
          if (showDropDown)
            Column(
              children: articles.sublist(3).map((article) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () => launchUrl(Uri.parse(article['link']!)),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              article['imageSrc']!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  article['title']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
