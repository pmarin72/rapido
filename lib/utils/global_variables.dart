import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rapido/screens/add_post_screen.dart';
import 'package:rapido/screens/feed_screen.dart';
import 'package:rapido/screens/profile_screen.dart';
import 'package:rapido/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> HomeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('favorite'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
