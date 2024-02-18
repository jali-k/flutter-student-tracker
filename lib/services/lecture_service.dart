


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:spt/model/folder.dart';
import 'package:spt/model/lectures.dart';

class LectureService{
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<List<Folder>> getLectures() async {
    List<Folder> folders = [];
    //get user Email
    String email = _auth.currentUser!.email.toString();
    try {

      QuerySnapshot snap = await _firestore.collection('folders').get();
      for (var element in snap.docs) {
          Folder folder = Folder.fromMap(element.data() as Map<String, dynamic>);
          folders.add(folder);
          //get video list
          QuerySnapshot videoSnap = await _firestore.collection('folders').doc(element.id).collection('videoDetails').get();
          List<Lecture> videoList = [];
          for (var video in videoSnap.docs) {
            Lecture lecture = Lecture.fromMap(video.data() as Map<String, dynamic>);
            videoList.add(lecture);
          }
          folder.setVideoList(videoList);
      }
      // sort by date
      folders.sort((a, b) => a.videoUploadedDate.compareTo(b.videoUploadedDate));
      return folders;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<String> getVideoUrl(String videoId) async {
    Reference ref = _storage.ref().child('videos').child(videoId);
    return await ref.getDownloadURL();
  }
}