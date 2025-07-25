import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';

import '../../constants/constants.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_sharp,
                                color: MAIN_COLOR,
                                size: 30,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "سياسه الخصوصيه",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container()
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                          "Privacy PolicyUpdated at 2023-12-07Fawri (“we,” “our,” or “us”) is committed to protecting your privacy. This Privacy Policy explains how your personal information is collected, used, and disclosed by Fawri.This Privacy Policy applies to our website, and its associated subdomains (collectively, our “Service”) alongside our application, Fawri. By accessing or using our Service, you signify that you have read, understood, and agree to our collection, storage, use, and disclosure of your personal information as described in this Privacy Policy and our Terms of Service. This Privacy Policy was created with Termify.Definitions and key termsTo help explain things as clearly as possible in this Privacy Policy, every time any of these terms are referenced, are strictly defined as:Cookie: small amount of data generated by a website and saved by your web browser. It is used to identify your browser, provide analytics, remember information about you such as your language preference or login information.Company: when this policy mentions “Company,” “we,” “us,” or “our,” it refers to Fawri, Palestine that is responsible for your information under this Privacy Policy.Country: where Fawri or the owners/founders of Fawri are based, in this case is PalestineCustomer: refers to the company, organization or person that signs up to use the Fawri Service to manage the relationships with your consumers or service users.Device: any internet connected device such as a phone, tablet, computer or any other device that can be used to visit Fawri and use the services.IP address: Every device connected to the Internet is assigned a number known as an Internet protocol (IP) address. These numbers are usually assigned in geographic blocks. An IP address can often be used to identify the location from which a device is connecting to the Internet.Personnel: refers to those individuals who are employed by Fawri or are under contract to perform a service on behalf of one of the parties.Personal Data: any information that directly, indirectly, or in connection with other information — including a personal identification number — allows for the identification or identifiability of a natural person.Service: refers to the service provided by Fawri as described in the relative terms (if available) and on this platform.Third-party service: refers to advertisers, contest sponsors, promotional and marketing partners, and others who provide our content or whose products or services we think may interest you.Website: Fawri's site, which can be accessed via this URL:You: a person or entity that is registered with Fawri to use the Services."),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Html text1() {
    return Html(data: _htmlContent);
  }

  final _htmlContent = """
  <div>
    <p>سياسة الخصوصية </p>
    <p>عزيزي المستخدم، عزيزتي  المستدمه ..</p>
    <p>أهلا بكم في أفضل و أحدث تطبيق للتسوق في عالم   
يرجى من حضرتكم الإحاطة بالأمور التالية:</p>
    <p>-نقاط مجانية، تحصلون عليها عند كل عملية شراء من متجر Pal-Dent يمكنكم استبدالها في أي وقت بمنتجات قيّمة من المتجر 
</p>
    <p>-يمكنكم متابعة حالة الطلبيات من خلال التطبيق </p>
    <p>التطبيق يشمل التوصيل لكافة مناطق الضفة الغربية والقدس و الداخل</p>
    <p>التوصيل مجاني من خلال مندوبي Kliamr في المدن التالية:
جنين، نابلس، طولكرم و قلقيلية</p>
    <p>تكلفة التوصيل تضاف للطلبية بقيمة 20 شيقل للمناطق الأخرى داخل الضفة</p>
    <p>-طريقة الدفع المعتمدة لدى المتجر هي الدفع نقدا عند الاستلام</p>
    <p>تكلفة التوصيل تضاف للطلبية بقيمة 20 شيقل للمناطق الأخرى داخل الضفة</p>
    <p>مع كل المودة لحضراتكم .. استمتعوا بالتسوق لدى متجركم Kliamr الأفضل في فلسطين</p>
  </div>
  """;
}
