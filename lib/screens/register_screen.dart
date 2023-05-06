import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tinder_itc/screens/register_pages.dart';
import 'package:tinder_itc/widgets/multi_select_chip_widget.dart';
import 'package:tinder_itc/widgets/text_email_widget.dart';
import 'package:tinder_itc/widgets/text_form_widget.dart';
import 'package:tinder_itc/widgets/text_pass_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final ValueNotifier<int> _index = ValueNotifier<int>(0);
  int _currentIndex = 0;
  int _finalIndex = 3;
  List<String?>? interests;
  TextEmailWidget textEmail= TextEmailWidget('Correo', 'Ingresa tu correo', 'Ingresa un correo valido');
  TextPassWidget txtPass = TextPassWidget();
  TextFormWidget txtDescripcion = TextFormWidget.area('Describete a tí mismo', 'Cuentanos algo!','Por favor, ingresa una descripción', Icons.handshake_outlined, 1, 250, 5);
  MultiSelectChipWidget? multiSelectInter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    interests =[
      'cafe','fiesta','estudio','comida','películas', 'deporte','tv','novelas','musica','pareja','amigos','casual','cena','gracioso','libros','netflix','atardecer'
    ];
    multiSelectInter = MultiSelectChipWidget(items: interests!);
  }

  
  Widget _showPage(){
    switch(_index.value){
      case 0:
        return RegisterPage1(txtEmail: textEmail, txtPass: txtPass,);
      case 1:
        return RegisterPage2(txtDescripcion: txtDescripcion,);
      case 2:
        return RegisterPage3(multiSelectorChip: multiSelectInter,);
      case 3:
        return const RegisterSuccess();
      default:
        return Container();
    }
  }

  void getScreenDataAndValidate(){

    switch(_index.value){
      case 0:
        if(textEmail.formKey.currentState!.validate() && txtPass.formKey.currentState!.validate()){
          print(textEmail.controlador+' '+txtPass.controlador+' '+RegisterPage1.image.toString());
          //meter data en objeto/provider/algo
          _index.value++;
        }
      break;

      case 1:
        if(txtDescripcion.formKey.currentState!.validate()){
          print(txtDescripcion.controlador+' '+RegisterPage2.selectedCareer.toString()+' '+RegisterPage2.selectedSemester.toString());
          _index.value++;
        }
      break;

      case 2:
        if(multiSelectInter!.formKey.currentState!.validate()){
          print(multiSelectInter!.interestsList);
          _index.value++;
        }

        //Aqui se manda el registro a firebase auth y storage
      break;

    }
  }



  //ValueListenableBuilder para no usar setState? Se escucha el cambio de _currentIndex
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black)
              ),
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
              child: ValueListenableBuilder(
                valueListenable: _index,
                builder: (context,value,_){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LinearPercentIndicator(
                        percent: (value/_finalIndex)>1||(value/_finalIndex)<0?0:(value/_finalIndex),
                        progressColor: Colors.green,
                        lineHeight: 5,
                        animation: true,
                        animationDuration: 500,
                        animateFromLastPercent: true,
                        width: MediaQuery.of(context).size.width*0.85,
                        alignment: MainAxisAlignment.center,
                      ),
                      _showPage(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: (_index.value==3)?
                        [
                          ElevatedButton(onPressed: ()=>Navigator.pushNamed(context, '/login'), child: const Text('Regresar al inicio'))
                        ]:
                        [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(20),
                              shape: const CircleBorder(),
                              backgroundColor: (_index.value==0)? Color.fromARGB(255, 237, 102, 92):Colors.white
                            ),
                            child: (_index.value==0)? 
                            const Icon(
                              Icons.clear,
                              size: 50,
                            ):
                            const Icon(
                              Icons.arrow_back_ios_new,
                              size: 50,
                            ),
                            onPressed: (){
                              _index.value--;
                              if(_index.value<0){
                                Navigator.pushNamed(context, '/login');
                              }
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(20),
                              shape: const CircleBorder(),
                              backgroundColor: (_index.value==2)? Color.fromARGB(255, 123, 230, 126):Colors.white
                            ),
                            child: (_index.value==2)?
                            const Icon(Icons.check, size: 50):
                            const Icon(Icons.arrow_forward_ios, size: 50),
                            onPressed: (){
                              getScreenDataAndValidate();
                            },
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      /* floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            _currentIndex++;
          });
        },
        child: const Icon(Icons.arrow_forward_ios),
      ), */
    );
  }
}