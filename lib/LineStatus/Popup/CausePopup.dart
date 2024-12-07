import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmc/LineStatus/Reuseable/PopupButton.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class CausePopup extends StatefulWidget {
  final String documentId;

  const CausePopup({super.key, required this.documentId});

  @override
  State<CausePopup> createState() => _CausePopupState();
}

class _CausePopupState extends State<CausePopup> {
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedImage;
  double _uploadProgress = 0.0;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadData() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description.')),
      );
      return;
    }

    String? imageUrl;

    // Upload image to Firebase Storage if an image is selected
    if (_selectedImage != null) {
      String fileName = path.basename(_selectedImage!.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('issue_images/$fileName');

      try {
        setState(() {
          _isUploading = true;
        });

        UploadTask uploadTask = firebaseStorageRef.putFile(_selectedImage!);
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        });

        TaskSnapshot taskSnapshot = await uploadTask;
        imageUrl = await taskSnapshot.ref.getDownloadURL();

        print("Image uploaded successfully. Image URL: $imageUrl");
      } catch (e) {
        print("Image upload failed with error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
        setState(() {
          _isUploading = false;
          _uploadProgress = 0.0;
        });
        return;
      }
    } else {
      print("No image selected for upload.");
    }

    // Prepare cause data without timestamp
    Map<String, dynamic> causeData = {
      'description': _descriptionController.text,
      'imageUrl': imageUrl,
    };

    try {
      print("Starting Firestore update...");
      print("Document ID to search for: ${widget.documentId}");

      // Query the downedLines collection to find the correct document by lineId only
      FirebaseFirestore.instance
          .collection('downedLines')
          .where('lineId', isEqualTo: widget.documentId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get()
          .then((snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          DocumentReference downedLineRef = snapshot.docs.first.reference;

          print("Matching document found: ${downedLineRef.id}");

          // Update the document to add the cause data
          await downedLineRef.update({
            'cause': FieldValue.arrayUnion([causeData]),
            'timestamp':
                FieldValue.serverTimestamp(), // Set timestamp separately
          });

          print("Firestore update successful.");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Issue submitted successfully!')),
          );
          Navigator.of(context)
              .pop(); // Close the popup after successful upload
        } else {
          // No matching document found, log more information
          print('No matching downedLines document found.');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No matching document found to update.')),
          );
        }
      }).catchError((error) {
        print('Failed to get downedLines document: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit issue: $error')),
        );
      });
    } catch (e) {
      print("Firestore update failed with error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit issue: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.95,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: GMCColors.darkGrey,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(6.0),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset('images/popback.svg'),
                  ),
                  Text(
                    'CAUSE',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: GMCColors.orange,
                    ),
                  ),
                  SizedBox(width: 24.0),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(6.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Describe the issue:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        height: 260,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: GMCColors.darkGrey,
                          ),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 12,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Enter the description here...',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        'Add an Image of the issue:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 240,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: GMCColors.darkGrey,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: _selectedImage == null
                              ? Center(
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 50.0,
                                    color: GMCColors.darkGrey,
                                  ),
                                )
                              : Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      if (_isUploading)
                        Column(
                          children: [
                            Text(
                              'Uploading image...',
                              style: TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            LinearProgressIndicator(
                              value: _uploadProgress,
                              backgroundColor: GMCColors.darkGrey,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  GMCColors.orange),
                            ),
                          ],
                        ),
                      const SizedBox(height: 24.0),
                      // Submit Button
                      Center(
                        child: PopupButton(
                          onTap: _uploadData,
                          buttonColor: GMCColors.orange,
                          buttonText: "Submit",
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
    );
  }
}
