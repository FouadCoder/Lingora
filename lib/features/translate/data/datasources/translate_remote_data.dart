import 'package:lingora/features/translate/data/models/translate_model.dart';
import 'package:lingora/features/translate/domain/usecases/translate_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TranslateRemoteData {
  final SupabaseClient supabaseClient;

  TranslateRemoteData(this.supabaseClient);

  // Save translate
  Future<TranslateModel> translate(TranslateParams params) async {
    final res = await supabaseClient.functions.invoke('translate', body: {
      "user_id": params.userId,
      "input": params.input,
      "translate_from": params.from,
      "translate_to": params.to,
    });
    return TranslateModel.fromJson(res.data);
  }
}
