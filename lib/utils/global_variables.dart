import 'package:flutter/material.dart';
import 'package:rapido/screens/add_post_screen.dart';
import 'package:rapido/screens/feed_screen.dart';

const webScreenSize = 600;

const HomeScreenItems = [
  FeedScreen(),
  Text('search'),
  AddPostScreen(),
  Text('favorite'),
  Text('profile'),
];
