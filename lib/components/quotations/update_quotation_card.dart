import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:tamini_app/common/enum.dart';
import 'package:tamini_app/common/quotation_service.dart';
import 'package:tamini_app/components/custom_button.dart';
import 'package:tamini_app/components/custom_text_field.dart';
import 'package:tamini_app/components/decorated_row_card.dart';
import 'package:tamini_app/components/quotations/quotation_card_item.dart';
import 'package:tamini_app/components/quotations/quotation_more_details.dart';
import 'package:tamini_app/components/quotations/quotations_model.dart';
import 'package:tamini_app/components/quotations/update_quotation_status.dart';

class UpdateQuotationCard extends StatefulWidget {
  const UpdateQuotationCard({
    Key? key,
    required this.request,
  }) : super(key: key);

  final Quotations request;

  @override
  State<UpdateQuotationCard> createState() => _UpdateQuotationCardState();
}

class _UpdateQuotationCardState extends State<UpdateQuotationCard> {
  QuotationService quotationService = QuotationService();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedRowCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RequestCardItem(
                      itemDescription: "request_id".i18n(),
                      itemValue: widget.request.requestId,
                    ),
                    RequestCardItem(
                      itemDescription: "request_status".i18n(),
                      itemValue: widget.request.status.i18n(),
                    ),
                    UpdateQuotationStatus(
                      requestId: widget.request.requestId,
                    )
                  ],
                ),
              ),
              widget.request.status == QuotationStatus.pending.name ||
                      widget.request.status == QuotationStatus.newRequest.name
                  ? Column(
                      children: [
                        const Divider(),
                        DecoratedRowCard(
                          child: UpdateQuotationCardItem(
                            requestId: widget.request.requestId,
                            itemDescription: "insurance_amount".i18n(),
                            itemValue: widget.request.insuranceAmount.toString(),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const Divider(),
                        DecoratedRowCard(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              RequestCardItem(
                                itemDescription: "insurance_amount".i18n(),
                                itemValue: widget.request.insuranceAmount.toString(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              const Divider(),
              QuotationMoreDetails(
                request: widget.request,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateQuotationCardItem extends StatefulWidget {
  const UpdateQuotationCardItem({
    super.key,
    required this.itemDescription,
    required this.itemValue,
    required this.requestId,
  });
  final String requestId;
  final String itemValue;
  final String itemDescription;

  @override
  State<UpdateQuotationCardItem> createState() => _UpdateQuotationCardItemState();
}

class _UpdateQuotationCardItemState extends State<UpdateQuotationCardItem> {
  @override
  void initState() {
    super.initState();
    itemValueController.text = widget.itemValue;
  }

  QuotationService quotationService = QuotationService();
  TextEditingController itemValueController = TextEditingController();
  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.itemDescription,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomButton(
          borderRadius: 4,
          vertical: 8,
          buttonText: '',
          isText: false,
          child: Icon(
            isEdit ? Icons.done : Icons.edit,
            size: isEdit ? 30 : 20,
          ),
          onPressed: () async {
            isEdit
                ? await quotationService.updateQuotation(
                    context,
                    widget.requestId,
                    {"insuranceAmount": double.parse(itemValueController.text), 'status': QuotationStatus.pending.name},
                    "${'Status updated to :'.i18n()} ${QuotationStatus.pending.name.i18n()}")
                : null;
            setState(() {
              isEdit = !isEdit;
            });
          },
        ),
        isEdit
            ? SizedBox(
                width: 90,
                child: CustomTextField(
                  controller: itemValueController,
                  labelText: '',
                  hintText: '',
                  keyboardType: TextInputType.number,
                ),
              )
            : Text(
                widget.itemValue,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ],
    );
  }
}
