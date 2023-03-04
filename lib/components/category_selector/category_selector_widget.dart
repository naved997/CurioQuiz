import '/auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/components/value_selector/value_selector_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'category_selector_model.dart';
export 'category_selector_model.dart';

class CategorySelectorWidget extends StatefulWidget {
  const CategorySelectorWidget({
    Key? key,
    this.gameRef,
  }) : super(key: key);

  final DocumentReference? gameRef;

  @override
  _CategorySelectorWidgetState createState() => _CategorySelectorWidgetState();
}

class _CategorySelectorWidgetState extends State<CategorySelectorWidget> {
  late CategorySelectorModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CategorySelectorModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GamesRecord>(
      stream: GamesRecord.getDocument(widget.gameRef!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primaryColor,
              ),
            ),
          );
        }
        final listViewGamesRecord = snapshot.data!;
        return Builder(
          builder: (context) {
            final categories = listViewGamesRecord.categories!.toList();
            return ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: categories.length,
              itemBuilder: (context, categoriesIndex) {
                final categoriesItem = categories[categoriesIndex];
                return FutureBuilder<ApiCallResponse>(
                  future: CategoryCall.call(
                    id: categoriesItem,
                  ),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primaryColor,
                          ),
                        ),
                      );
                    }
                    final listTileCategoryResponse = snapshot.data!;
                    return InkWell(
                      onTap: () async {
                        final gamesUpdateData = createGamesRecordData(
                          currentCategory: categoriesItem,
                          currentCategoryName: getJsonField(
                            listTileCategoryResponse.jsonBody,
                            r'''$.title''',
                          ).toString(),
                        );
                        await widget.gameRef!.update(gamesUpdateData);
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: ValueSelectorWidget(
                                  gameRef: widget.gameRef,
                                ),
                              ),
                            );
                          },
                        ).then((value) => setState(() {}));
                      },
                      child: ListTile(
                        title: Text(
                          getJsonField(
                            listTileCategoryResponse.jsonBody,
                            r'''$.title''',
                          ).toString(),
                          style: FlutterFlowTheme.of(context).title3,
                        ),
                        tileColor: Color(0xFFF5F5F5),
                        dense: false,
                        contentPadding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 8.0, 15.0, 8.0),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
