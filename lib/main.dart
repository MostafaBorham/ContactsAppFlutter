import 'package:contacts_app/bloc/contacts_cubit.dart';
import 'package:contacts_app/data/cloud/dio_helper.dart';
import 'package:contacts_app/route_manager/app_routes.dart';
import 'package:contacts_app/route_manager/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>ContactsCubit())
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: onGenerate,
        initialRoute: AppRoutes.homePageRoute,
      ),
    );
  }
}
