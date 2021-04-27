import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../../screens/common/loading.dart';
import '../../domain/Shareable.dart';
import '../bloc/share_bloc.dart';

class Share extends StatelessWidget {
  final Shareable shareable;

  const Share({Key key, this.shareable}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Obrigado por compartilhar."),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<ShareBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ShareBloc>(),
      child: BlocConsumer<ShareBloc, ShareState>(
        listener: (context, state) {
          if (state is ShareError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.shareFailure.message),
              ),
            );
          } else if (state is Shared) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is Sharing) {
            return Loading();
          } else if (state is ShareInitial) {
            BlocProvider.of<ShareBloc>(context)
                .add(ShareContent(shareable: shareable));
          }
          return Loading();
        },
      ),
    );
  }
}
