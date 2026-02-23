import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddJournal extends StatefulWidget {
  const AddJournal({super.key});

  @override
  State<AddJournal> createState() => _AddJournalState();
}

class _AddJournalState extends State<AddJournal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF5F0FF),
        leading: IconButton(
          icon: Icon(Icons.close, color: Color(0xFF9B7EBD)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "New Journal",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9B7EBD),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 50),
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF9B7EBD),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        height: 28,
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 14,
                              color: Colors.black87,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Today, ${DateFormat('MMM d').format(DateTime.now())}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Title",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFF5F0FF),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F0FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Title...",
                            hintStyle: GoogleFonts.poppins(
                              color: Color(0xFF9B7EBD),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9B7EBD),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Note",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFF5F0FF),
                        ),
                      ),
                      SizedBox(height: 8),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F0FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: "Note...",
                                hintStyle: GoogleFonts.poppins(
                                  color: Color(0xFF9B7EBD),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF9B7EBD),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add Media",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFF5F0FF),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          /// PHOTO
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                print("Photo ditekan");
                              },
                              child: Container(
                                height: 90,
                                decoration: BoxDecoration(
                                  color: Color(0xFF9B7EBD),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Photo",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 16),

                          /// VIDEO
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                print("Video ditekan");
                              },
                              child: Container(
                                height: 90,
                                decoration: BoxDecoration(
                                  color: Color(0xFF9B7EBD),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.videocam,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Video",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Preview",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFF5F0FF),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 140,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F0FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    print("Save ditekan");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save, color: Color(0xFFF5F0FF), size: 28),
                          SizedBox(width: 10),
                          Text(
                            "Save",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFF5F0FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    print("Draft ditekan");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xFF9B7EBD),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.drafts, color: Color(0xFF9B7EBD), size: 28),
                          SizedBox(width: 10),
                          Text(
                            "Save as Draft",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF9B7EBD),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
