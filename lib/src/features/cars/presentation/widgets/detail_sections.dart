import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/src/extensions.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:flutter/material.dart';

class LocationSec extends StatelessWidget {
  const LocationSec({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Ctext(
            'Similar',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}

class DescSec extends StatelessWidget {
  const DescSec({
    required this.th,
    super.key,
    required this.description,
  });

  final ThemeData th;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Ctext(
            color: Colors.black,
            'Description',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          10.spaceY,
          Ctext(
            color: Colors.black,
            description,
            fontSize: 14,
            fontWeight: FontWeight.w300,
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}

class DetailsSec extends StatelessWidget {
  const DetailsSec({
    required this.th,
    required this.details,
    super.key,
  });
  final List<dynamic> details;
  final ThemeData th;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          const Text(
            '    Fetures:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: List<Widget>.generate(details.length, (int index) {
                return CustomContainer(
                  padding: const EdgeInsets.all(10),
                  child: Text(details[index].toString()),
                  // backgroundColor: Colors.lightBlue[100],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class UpDetailsSec extends StatelessWidget {
  const UpDetailsSec({
    required this.th,
    required this.details,
    super.key,
    required this.cp,
  });
  final List<dynamic> details;
  final ThemeData th;
  final CarCreateProvider cp;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          const Text(
            'Fetures',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: List<Widget>.generate(details.length, (int index) {
                return Chip(
                  onDeleted: () {
                    cp.deleteFet(details[index]);
                  },
                  label: Text(details[index].toString()),
                  backgroundColor: Colors.lightBlue[100],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class SubSec extends StatelessWidget {
  final String name;
  final String title;
  const SubSec({
    super.key,
    required this.name,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
      child: ListTile(
        title: Ctext(
          title,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        trailing: Ctext(
          name,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class EditSection extends StatelessWidget {
  final String name;
  final String title;
  final ValueChanged<String> onChanged;
  // final TextEditingController controller;
  final TextInputType? keyboard;

  const EditSection({
    super.key,
    this.keyboard,
    required this.name,
    required this.title,
    required this.onChanged,
    // required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
      child: ListTile(
        subtitle: Ctext(
          title,
          fontSize: 13,
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          fontWeight: FontWeight.bold,
        ),
        title: CTextField(
          keyboardType: keyboard ?? TextInputType.name,
          onChanged: onChanged,
          labelText: name,
          suffixIcon: const Icon(Icons.edit_note_sharp), hintText: "New Value",
          // fontSize: 16,
          // fontWeight: FontWeight.w600,
        ),
        // trailing: IconButton(onPressed: onPress, icon: const Icon(Icons.edit)),
      ),
    );
  }
}

class PriceSec extends StatelessWidget {
  final String price;
  const PriceSec({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Ctext(
        'AED $price',
        fontSize: 20,
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
