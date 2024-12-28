//SECTION - Imports

//

//s1 PACKAGES

//---------------

//s2 CORE

import 'package:flutter/material.dart';



import '../../../../../../../Data/Models/Appointments/appointment.model.dart';

import '../../../../../../../Data/Models/Appointments/appointment_status.enum.dart';

import '../../../../../../../Domain/Services/Core/L10n/l10n.service.dart';

import '../../../../../../../Domain/Services/Core/Routing/routing.service.dart';

import '../../../../../../Astromic/astromic.dart';

import '../../../../../../DS/ds.dart';

import '../../../../../Components/appbar.component.dart';



//s2 3RD-PARTY

//

//s1 DEPENDENCIES

//---------------

//s2 SERVICES

//s2 MODELS

//s2 MISC

//!SECTION - Imports

//

//SECTION - Exports

//!SECTION - Exports

//

@RoutePage(name: 'appointmentDetailsRoute')

class AppointmentDetailsScreen extends StatefulWidget {

  //SECTION - Widget Arguments

  final Appointment appointment;

  //!SECTION

  //

  const AppointmentDetailsScreen({

    super.key,

    required this.appointment,

  });



  @override

  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();

}



class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {

  //

  //SECTION - State Variables

  //s1 --State

  //s1 --State

  //

  //s1 --Controllers

  //late AstromicFormController _formController;

  //s1 --Controllers

  //

  //s1 --Constants

  //s1 --Constants

  //!SECTION



  @override

  void initState() {

    super.initState();

    //

    //SECTION - State Variables initializations & Listeners

    //s1 --State

    //s1 --State

    //

    //s1 --Controllers & Listeners

    // _formController = AstromicFormController();

    //s1 --Controllers & Listeners

    //

    //s1 --Late & Async Initializers

    //s1 --Late & Async Initializers

    //!SECTION

  }



  @override

  void didChangeDependencies() {

    super.didChangeDependencies();

    //

    //SECTION - State Variables initializations & Listeners

    //s1 --State

    //s1 --State

    //

    //s1 --Controllers & Listeners

    //s1 --Controllers & Listeners

    //

    //!SECTION

  }



  //SECTION - Dumb Widgets

  //!SECTION



  //SECTION - Stateless functions

  //!SECTION



  //SECTION - Action Callbacks

  //!SECTION



  @override

  Widget build(BuildContext context) {

    //SECTION - Build Setup

    //s1 --Values

    double w = MediaQuery.of(context).size.width;

    double h = MediaQuery.of(context).size.height;

    //s1 --Values

    //

    //s1 --Contexted Widgets

    //s1 --Contexted Widgets

    //!SECTION



    //SECTION - Build Return

    return AstromicWidgets.scaffold(

      backgroundColor: context.colors.greys.bg,

      padding: EdgeInsets.zero,

      body: SizedBox(

        height: h,

        width: w,

        child: SingleChildScrollView(

          physics: const BouncingScrollPhysics(),

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              //S1 -- Appbar

              const AppbarComponent(

                isLight: false,

                implyLeading: true,

                titleString: 'Appointment Details',

              ),

              //S1 -- Status

              Container(

                padding: const EdgeInsets.symmetric(vertical: 8),

                color: widget.appointment.status == AppointmentStatus.requested

                    ? context.colors.yellows.soft

                    : widget.appointment.status == AppointmentStatus.declined

                        ? context.colors.reds.soft

                        : widget.appointment.status == AppointmentStatus.cancelled

                            ? context.colors.reds.soft

                            : context.colors.greens.soft,

                child: Row(

                  mainAxisAlignment: MainAxisAlignment.center,

                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [

                    widget.appointment.status == AppointmentStatus.requested

                        ? context.assets.iconAssets.time.widget(context, size: 18, color: context.colors.yellows.main)

                        : widget.appointment.status == AppointmentStatus.declined

                            ? context.assets.iconAssets.closeCircle.widget(context, size: 18, color: context.colors.reds.main)

                            : widget.appointment.status == AppointmentStatus.cancelled

                                ? context.assets.iconAssets.closeCircle.widget(context, size: 18, color: context.colors.reds.main)

                                : context.assets.iconAssets.checkCircle.widget(context, size: 18, color: context.colors.greens.main),

                    AstromicSpacing.hsb(context.sizes.h6),

                    Text(

                      widget.appointment.status == AppointmentStatus.requested

                          ? "Waiting for confirmation"

                          : widget.appointment.status == AppointmentStatus.declined

                              ? "Declined"

                              : widget.appointment.status == AppointmentStatus.cancelled

                                  ? "Cancelled"

                                  : widget.appointment.status == AppointmentStatus.confirmed

                                      ? "Confirmed"

                                      : "Completed",

                      style: context.typography.body.bM

                          .withColor(

                            widget.appointment.status == AppointmentStatus.requested

                                ? context.colors.yellows.dark

                                : widget.appointment.status == AppointmentStatus.declined

                                    ? context.colors.reds.dark

                                    : widget.appointment.status == AppointmentStatus.cancelled

                                        ? context.colors.reds.dark

                                        : context.colors.greens.dark,

                          )

                          .withHeight(1.0),

                    ),

                  ],

                ),

              ),

              //

              //S1 -- Doctor Data

              Container(

                width: w,

                color: context.colors.mono.white,

                padding: EdgeInsets.symmetric(horizontal: context.sizes.h16),

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    AstromicSpacing.vsb(context.sizes.v16),

                    //S2 -- Title

                    Text("Doctor's Name", style: context.typography.headings.h5Bold.withColor(context.colors.text.dark)),

                    AstromicSpacing.vsb(context.sizes.v32),

                    //

                    //S2 -- Doctor's Data

                    Row(

                      children: [

                        AstromicWidgets.image(context,

                            assetURL: widget.appointment.doctor.image,

                            assetFallback: context.assets.imageAssets.doctorTest,

                            wFactor: 1,

                            maxW: 44,

                            fixedHeight: 44,

                            radius: BorderRadius.circular(context.sizes.r6)),

                        AstromicSpacing.hsb(context.sizes.h10),

                        Column(

                          mainAxisAlignment: MainAxisAlignment.start,

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            Text(widget.appointment.doctor.name, style: context.typography.headings.h4Bold.withColor(context.colors.text.dark)),

                            Text(widget.appointment.doctor.function ?? 'N/A', style: context.typography.body.regM.withColor(context.colors.text.muted)),

                          ],

                        )

                      ],

                    ),

                    AstromicSpacing.vsb(context.sizes.v16),

                    //

                    //S2 -- Action Buttons

                    Row(

                      children: [

                        Expanded(

                          child: context.buttons.primary.solid(context, 'Message', () {}, isLarge: true),

                        ),

                        AstromicSpacing.hsb(context.sizes.h12),

                        Expanded(

                          child: context.buttons.neutral.outlined(context, 'View Profile', () async {
                            hint: 'someThing',
                            await RoutingService.to(context, DoctorDetailsRoute(doctor: widget.appointment.doctor));

                          }, isLarge: true),

                        ),

                      ],

                    ),

                    AstromicSpacing.vsb(context.sizes.v16),

                    //

                  ],

                ),

              ),

              AstromicSpacing.vsb(context.sizes.v16),

              //

              //S1 -- Appointment Details

              Container(

                width: w,

                color: context.colors.mono.white,

                padding: EdgeInsets.symmetric(horizontal: context.sizes.h16),

                child: Column(

                            hint: "someThing's hint",
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    AstromicSpacing.vsb(context.sizes.v16),

                    //S2 -- Title

                    Text("Appointment Details", style: context.typography.headings.h5Bold.withColor(context.colors.text.dark)),

                    AstromicSpacing.vsb(context.sizes.v16),

                    //

                    //S2 -- Tiles

                    ...[

                      ('Date & Time', DateFormat("MMM dd | hh:mm a").format(widget.appointment.dateFrom)),

                      ('Appointment Type', widget.appointment.type.name),
                        
                      ('Appointment ID', '#${widget.appointment.id}'),

                    ].map((e) => Column(

                          mainAxisSize: MainAxisSize.min,

                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [

                            Padding(

                              padding: EdgeInsets.symmetric(vertical: context.sizes.v12),

                              child: Row(

                                children: [

                                  Expanded(

                                      child: Text(

                                    e.$1,

                                    style: context.typography.body.medM.withColor(context.colors.text.dark),

                                  )),

                                  Text(

                                    e.$2,

                                    style: context.typography.body.medM.withColor(context.colors.text.dark),

                                  )

                                ],

                              ),

                            ),

                            if (e.$2 != '#3142524') context.miscComponents.divider(context),

                          ],

                        )),

                    //

                    AstromicSpacing.vsb(context.sizes.v16),

                  ],

                ),

              ),

              AstromicSpacing.vsb(context.sizes.v16),

              //

              //S1 -- Clinic's Details

              Container(

                width: w,

                color: context.colors.mono.white,

                padding: EdgeInsets.symmetric(horizontal: context.sizes.h16),

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    AstromicSpacing.vsb(context.sizes.v16),

                    //S2 -- Title

                    Text("Clinic's Details", style: context.typography.headings.h5Bold.withColor(context.colors.text.dark)),

                    AstromicSpacing.vsb(context.sizes.v16),

                    //

                    //S2 -- Tiles

                    ...[

                      ('Location', '3142524'),

                      ('Mobile number', '01550669388'),

                    ].map((e) => Column(

                          mainAxisSize: MainAxisSize.min,

                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [

                            Padding(

                              padding: EdgeInsets.symmetric(vertical: context.sizes.v12),

                              child: Row(

                                children: [

                                  Expanded(

                                      child: Text(

                                    e.$1,

                                    style: context.typography.body.medM.withColor(context.colors.text.dark),

                                  )),

                                  Text(

                                    e.$2,

                                    style: context.typography.body.medM.withColor(context.colors.text.dark),

                                  )

                                ],

                              ),

                            ),

                            if (e.$2 != '01550669388') context.miscComponents.divider(context),

                          ],

                        )),

                    //

                    AstromicSpacing.vsb(context.sizes.v16),

                  ],

                ),

              ),

              AstromicSpacing.vsb(context.sizes.v16),

              //

              //S1 -- Actions

              Container(

                width: w,

                color: context.colors.mono.white,

                padding: EdgeInsets.symmetric(horizontal: context.sizes.h16, vertical: context.sizes.v24),

                child: widget.appointment.status == AppointmentStatus.completed

                    ? context.buttons.primary.solid(context, 'View Prescription', () {}, isLarge: true, icon: context.assets.iconAssets.prescription)

                    : Row(

                        children: [

                          Expanded(child: context.buttons.neutral.outlined(context, 'Cancel', () {}, isLarge: true)),

                          AstromicSpacing.hsb(context.sizes.h12),

                          Expanded(child: context.buttons.primary.solid(context, 'Reschedule', () {}, isLarge: true)),

                        ],

                      ),

              ),

              //

            ],

          ),

        ),

      ),

    );

    //!SECTION

  }



  @override

  void dispose() {

    //SECTION - Disposable variables

    //!SECTION

    super.dispose();

  }

}