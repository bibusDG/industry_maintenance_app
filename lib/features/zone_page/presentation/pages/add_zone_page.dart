import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:industry_maintenance_app/core/my_widgets/custom_snackbar_widget.dart';
import 'package:industry_maintenance_app/core/my_widgets/custom_text_form_widget.dart';
import 'package:industry_maintenance_app/core/my_widgets/my_app_bar/presentation/pages/my_app_bar.dart';
import 'package:industry_maintenance_app/core/my_widgets/my_end_drawer/presentation/pages/my_end_drawer.dart';
import 'package:industry_maintenance_app/features/zone_page/presentation/bloc/add_zone_cubit/add_zone_cubit.dart';
import 'package:industry_maintenance_app/features/zone_page/presentation/bloc/zone_cubit.dart';

class AddZonePage extends HookWidget {
  final String? uid;
  const AddZonePage({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _zoneNameText = TextEditingController();
    final _snackBar = MySnackBar();


    final addZoneCubit = useBloc<AddZoneCubit>();
    final addZoneState = useBlocBuilder(addZoneCubit);
    useBlocListener<AddZoneCubit, AddZoneState>(addZoneCubit, (bloc, current, context) {
      current.whenOrNull(
        zoneExists: (message) => _snackBar.showSnackBar(message, context),
        zoneExistsError: (message) => _snackBar.showSnackBar(message, context),
        createZoneFailure: (message) => _snackBar.showSnackBar(message, context),
        createZoneSuccess: (message) async{
          await Future.delayed(const Duration(seconds: 2));
          if(context.mounted){
            context.goNamed('factory_zones', pathParameters: {'uid' : uid!});
          }
        }
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: addZoneState.whenOrNull(
            initial: () => Column(
              children: [
                AuthTextField(
                    keyName: '',
                    icon: const Icon(Icons.text_fields_outlined),
                    hintText: 'nazwa strefy',
                    controller: _zoneNameText,
                    obscure: false),
                const SizedBox(height: 30.0,),
                CupertinoButton(child: const Text('Utwórz'), onPressed: (){
                  addZoneCubit.checkForZone(zoneName: _zoneNameText.text, zonePicture: '');
                }),
              ],
            ),
            createZoneSuccess: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.greenAccent,),
              Text(message),
            ],)),
            addingNewZone: () => const Center(child: CircularProgressIndicator(),),
          ),
      ),
    );
  }
}
