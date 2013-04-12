

#include <Servo.h> 

int servoPin = 9;

int pirPin = 7;

int ledVermelloPin=6;

int ledAmareloPin=5;

int activaContaAtras=1;


//para comezar a contaAtras, angle=0
long comezoContaAtras;

//para o comezo da vixiancia, angle=180
long comezoVixia;

//sera o momento actual
long agora;

long duracionConta;

long duracionVixia;

long tempoContandoAtras;

int angle=0;

int xoga;
 
Servo servo;   

 
void setup() 
{ 
 servo.attach(servoPin);
 pinMode(pirPin,INPUT);
 pinMode(ledVermelloPin,OUTPUT);
 pinMode(ledAmareloPin,OUTPUT);
 xoga=1;
 Serial.begin(9600); 
} 
 
 
void loop() 
{ 
if (xoga==1)
{
  inicio();
}
contaAtras();
 
} 

//funcion inicio para comezar o xogo, empeza de costas, mira adiante, mira atras
//e queda de costas para comezar a conta atras
void inicio(){
  digitalWrite(ledVermelloPin,HIGH);
  Serial.println("comezando");
  angle=0;
  servo.write(angle);
  delay (4000);
  Serial.println("comeza a xirarse despazo");
  for (int i=0;i<90;i++){
    servo.write(i);
    delay(50);
  }
  Serial.println("mira de frente");
  angle=180;
  servo.write(angle);
  delay(2000);
  
  Serial.println("comeza a dar a volta");
  for (int i=180;i>140;i--){
    servo.write(i);
    delay(50);
  }
  
  Serial.println("mirando para atras");
  angle=0;
  servo.write(angle);
  delay(1000);
  
  xoga=0;
  
  
 }

//funcion de conta atras, cunha duracion entre 3 e 6 segundos
//queda mirando para diante
void contaAtras() {
  //gardamos o comezo da conta atras
  if (activaContaAtras==1)
  {
    digitalWrite(ledVermelloPin,LOW);
    digitalWrite(ledAmareloPin,HIGH);
    duracionConta= random(3,6)*1000L;
    Serial.println("comezando conta atras");
    Serial.print("mirando en: ");
    Serial.println(duracionConta);
    comezoContaAtras=millis();
    activaContaAtras=0;
  }
  
  long agora=millis();
  
 if (agora>(duracionConta+comezoContaAtras)){
  moveServo(180);
  //para darlle tempo a xirar, chequear se vai ben
  delay (1000);
  comezoVixia=millis();
   //definimolo aqui para que non se redefina cada vez que se executa o ciclo de vixia()
  duracionVixia=random(5,8)*1000L;
  Serial.print("vixiando ");
  Serial.println(duracionVixia);
  digitalWrite(ledVermelloPin,HIGH);
  digitalWrite(ledAmareloPin,LOW); 
  vixia();
 }
}

//funcion vixia, mira cara adiante cunha duracion entre 7 e 10 segundos
//se detecta movemento salta e se non volta a conta atras
void vixia(){
//  delay(3000);
  if(digitalRead(pirPin) == LOW)
    {
    long agora=millis();
//      Serial.println(agora);
//      Serial.print("duracion Vixia ");
//      Serial.println(duracionVixia);
//      Serial.print("comezo Vixia ");
//      Serial.println(comezoVixia);
//      delay(1000);
      
      if (agora>(duracionVixia+comezoVixia))
        {
        moveServo(0);
        long duracionConta= random(3,6)*1000L;
        Serial.print("contando atras durante");
        Serial.println(duracionConta);
         //reiniciamos e comezamos a conta atras
        long comezoContaAtras=millis();
        activaContaAtras=1;
        contaAtras();
        }
        else
        {
          vixia();
        }
    }
  
  else 
  {    
    perdiches();
  }
        
}
  

void perdiches()
  {
    Serial.println("PILLEICHE!");
    int i=0;
    while (i<20)
    {
    digitalWrite(ledVermelloPin,HIGH);
    digitalWrite(ledAmareloPin,LOW);
    delay(100);
    digitalWrite(ledVermelloPin,LOW);
    digitalWrite(ledAmareloPin,HIGH);
    delay(100);
    i++;
  }
  digitalWrite(ledVermelloPin,HIGH);
  delay(2000);
  digitalWrite(ledVermelloPin,LOW);
  digitalWrite(ledAmareloPin,LOW);
  xoga=1;
  activaContaAtras=1;
  }

void moveServo(int angle){
  servo.write(angle);
}
  
  
