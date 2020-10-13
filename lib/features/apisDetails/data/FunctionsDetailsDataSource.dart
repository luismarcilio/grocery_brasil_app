import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:meta/meta.dart';

import '../domain/BackendFunctionsConfiguration.dart';

abstract class FunctionsDetailsDataSource {
  Future<BackendFunctionsConfiguration> getBackendFunctionsConfiguration();
}

class FunctionsDetailsDataSourceImpl implements FunctionsDetailsDataSource {
  final FirebaseFirestore firebaseFirestore;
  BackendFunctionsConfiguration backendFunctionsConfigurationCache;

  FunctionsDetailsDataSourceImpl({@required this.firebaseFirestore});

  @override
  Future<BackendFunctionsConfiguration>
      getBackendFunctionsConfiguration() async {
    if (this.backendFunctionsConfigurationCache != null) {
      return this.backendFunctionsConfigurationCache;
    }
    final firestoreDocSnapshot =
        await firebaseFirestore.collection('apiConfiguration').doc('v1').get();
    if (!firestoreDocSnapshot.exists) {
      throw FunctionsDetailsDataSourceException(
          messageId: MessageIds.NOT_FOUND);
    }

    this.backendFunctionsConfigurationCache =
        BackendFunctionsConfiguration.fromJson(firestoreDocSnapshot.data());
    return this.backendFunctionsConfigurationCache;
  }
}
