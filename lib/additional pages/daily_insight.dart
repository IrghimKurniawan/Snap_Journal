import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/journal_services.dart';
import 'package:snap_journal/services/language_provider.dart';

class DailyInsight extends StatefulWidget {
  final String journalId;

  const DailyInsight({super.key, required this.journalId});

  @override
  State<DailyInsight> createState() => _DailyInsightState();
}

class _DailyInsightState extends State<DailyInsight> {
  Map<String, dynamic>? insightData;

  List<Map<String, String>> messages = [];
  TextEditingController chatController = TextEditingController();

  bool isLoading = true;
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    fetchInsight();
  }

  Future<void> fetchInsight() async {
    final res = await JournalServices.analyzeJournal(widget.journalId);

    setState(() {
      insightData = res?['data'];
      isLoading = false;
    });
  }

  Future<void> sendChat() async {
    if (chatController.text.isEmpty || isSending) return;

    final userMessage = chatController.text;

    setState(() {
      messages.add({"role": "user", "message": userMessage});
      chatController.clear();
      isSending = true;
    });

    final res =
        await JournalServices.chatJournal(widget.journalId, userMessage);

    if (res != null) {
      setState(() {
        messages.add({
          "role": "bot",
          "message": res['data']['reply'] ?? "AI tidak memberikan jawaban"
        });
      });
    }

    setState(() {
      isSending = false;
    });
  }

  Future<void> enhanceJournal() async {
    final res = await JournalServices.enhanceJournal(
      widget.journalId,
    );

    if (res == null) return;

    if (res.containsKey('errors')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['errors']),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['data']['enhanced_text']),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;

    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF9B7EBD),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF9B7EBD),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFF5F0FF), size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF9B7EBD),
        elevation: 0,
        title: Text(
          t['daily_insight_title'] ?? "Daily Insight",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFF5F0FF),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFF5F0FF),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF9B7EBD),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.psychology,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      insightData?['title'] ??
                          t['insight_positive'] ??
                          "Insight",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF9B7EBD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      insightData?['chatbot_highlight'] ?? "",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF9B7EBD),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Chat with AI",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F0FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: messages.isEmpty
                          ? Center(
                              child: Text(
                                "Mulai chat dengan AI tentang jurnalmu",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final msg = messages[index];
                                final isUser = msg['role'] == 'user';

                                return Align(
                                  alignment: isUser
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? const Color(0xFF9B7EBD)
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      msg['message'] ?? '',
                                      style: GoogleFonts.poppins(
                                        color: isUser
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: chatController,
                            decoration: const InputDecoration(
                              hintText: "Tanya tentang jurnalmu...",
                              hintStyle: TextStyle(
                                color: Color(0xFF9B7EBD),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: isSending
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.send),
                          color: const Color(0xFF9B7EBD),
                          onPressed: sendChat,
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: enhanceJournal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B5FA7),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Enhance",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
