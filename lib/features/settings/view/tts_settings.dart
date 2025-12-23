import 'package:aut_toolkit/core/services/tts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/strings.g.dart';

class TtsSettingsTile extends ConsumerStatefulWidget {
  const TtsSettingsTile({super.key});

  @override
  ConsumerState<TtsSettingsTile> createState() => _TtsSettingsTileState();
}

class _TtsSettingsTileState extends ConsumerState<TtsSettingsTile> {
  double _speechRate = TtsService.getSpeechRate();
  double _volume = TtsService.getVolume();
  double _pitch = TtsService.getPitch();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.record_voice_over_outlined),
      title: Text(t.tts_settings),
      subtitle: Text(
        '${t.tts_rate}: ${_speechRate.toStringAsFixed(1)}, '
            '${t.tts_volume}: ${_volume.toStringAsFixed(1)}, '
            '${t.tts_pitch}: ${_pitch.toStringAsFixed(1)}',
      ),
      onTap: () => _showTtsDialog(context),
    );
  }

  Future<void> _showTtsDialog(BuildContext context) async {
    double rate = _speechRate;
    double volume = _volume;
    double pitch = _pitch;

    final result = await showDialog<_TtsValues>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.tts_settings),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SliderTile(
                    label: t.tts_rate,
                    value: rate,
                    min: 0.5,
                    max: 2.0,
                    onChanged: (v) => setDialogState(() => rate = v),
                  ),
                  _SliderTile(
                    label: t.tts_volume,
                    value: volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (v) => setDialogState(() => volume = v),
                  ),
                  _SliderTile(
                    label: t.tts_pitch,
                    value: pitch,
                    min: 0.5,
                    max: 2.0,
                    onChanged: (v) => setDialogState(() => pitch = v),
                  ),
                  Divider(),
                  ElevatedButton.icon(onPressed: () async {
                    await TtsService.setSpeechRate(rate);
                    await TtsService.setVolume(volume);
                    await TtsService.setPitch(pitch);
                    TtsService.speakTest();
                  }, label: Text(t.tts_test), icon: const Icon(Icons.audiotrack_outlined),)
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await TtsService.setSpeechRate(_speechRate);
                await TtsService.setVolume(_volume);
                await TtsService.setPitch(_pitch);
                Navigator.of(context).pop();
              },
              child: Text(t.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(
                _TtsValues(rate, volume, pitch),
              ),
              child: Text(t.save),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        _speechRate = result.rate;
        _volume = result.volume;
        _pitch = result.pitch;
      });

      await TtsService.setSpeechRate(result.rate);
      await TtsService.setVolume(result.volume);
      await TtsService.setPitch(result.pitch);
    }
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(1)}'),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * 10).toInt(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _TtsValues {
  final double rate;
  final double volume;
  final double pitch;

  const _TtsValues(this.rate, this.volume, this.pitch);
}

