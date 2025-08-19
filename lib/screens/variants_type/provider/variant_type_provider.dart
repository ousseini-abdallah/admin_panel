
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../models/variant_type.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class VariantsTypeProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addVariantsTypeFormKey = GlobalKey<FormState>();
  TextEditingController variantNameCtrl = TextEditingController();
  TextEditingController variantTypeCtrl = TextEditingController();

  VariantType? variantTypeForUpdate;



  VariantsTypeProvider(this._dataProvider);


  //TODO: should complete addVariantType
  addVariantType() async {
    try {
      Map<String, dynamic> variantType = {'name': variantNameCtrl.text, 'type': variantTypeCtrl.text};

      final response  = await service.addItem(endpointUrl: 'variantTypes', itemData: variantType);
      if(response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllVariantType();
          log('Variant Type  added');
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to add variant type: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      rethrow;
    }
  }

  //TODO: should complete updateVariantType
  updateVariantType() async {
    try {
      if ( variantTypeForUpdate != null) {
        Map<String, dynamic> variantType = {'name': variantNameCtrl.text, 'type': variantTypeCtrl.text};

        final response = await service.updateItem(endpointUrl: 'variantTypes', itemId: variantTypeForUpdate?.sId ?? '', itemData: variantType);
        if(response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if(apiResponse.success == true) {
            clearFields();
            SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
            log('Variant Type  added');
            _dataProvider.getAllVariantType();
          } else {
            SnackBarHelper.showErrorSnackBar('Failed to add Variant Type: ${apiResponse.message}');
          }
        } else {
          SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
        }
      }
    }  catch (e) {
      SnackBarHelper.showErrorSnackBar('An error occured: $e');
      rethrow;
    }
  }

  //TODO: should complete submitVariantType
  submitVariantType() {
    if (variantTypeForUpdate != null) {
      updateVariantType();
    } else {
      addVariantType();
    }
  }

  //TODO: should complete deleteVariantType
  deleteVariantType(VariantType variantType) async {
    try {
      Response response = await service.deleteItem(endpointUrl: 'variantTypes', itemId: variantType.sId ?? '');
      if(response.isOk) {
        ApiResponse apiResponse  = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Sub Variant type deleted successfully');
          _dataProvider.getAllVariantType();
        } else {
          SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
        }
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  setDataForUpdateVariantTYpe(VariantType? variantType) {
    if (variantType != null) {
      variantTypeForUpdate = variantType;
      variantNameCtrl.text = variantType.name ?? '';
      variantTypeCtrl.text = variantType.type ?? '';
    } else {
      clearFields();
    }
  }

  clearFields() {
    variantNameCtrl.clear();
    variantTypeCtrl.clear();
    variantTypeForUpdate = null;
  }
}
