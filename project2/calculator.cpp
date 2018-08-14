#include "calculator.hpp"
#include <string>
#include <cmath>
#include <iostream>

// Scanner implementation

// You may have to modify this constructor, although it might not be neccessary.
Scanner::Scanner() : line(1), value(0)
                      {
    // WRITEME
}

// You need to fill this method with the appropriate code for it to work as described in the project description.
Token Scanner::nextToken() {
    // I am a placeholder. Change me into something that can actually decypher the next token without consuming it.
    // WRITEME
  while(std::cin.peek()==' ' || std::cin.peek()=='\n' || std::cin.peek()=='\t' ||
	std::cin.peek()=='\f' || std::cin.peek()=='\v' || std::cin.peek()=='\r'){
	if(std::cin.peek()=='\n'){
	  line++;
	  return T_NEWLN;
	}
	std::cin.get();
  }
  std::string s="";
  char c=std::cin.peek();
  if(std::isdigit(c)){
       std::cin.get(c);
       s.push_back(c);
       while(std::cin.peek()>='0' &&std::cin.peek()<='9'){
         std::cin.get(c);
         s.push_back(c);
       }
       value=stoi(s);

    return T_NUMBER;
  }
  else{
    switch(std::tolower(c)){
    case ';':
      return T_SEMICOLON;
    case '+':
      return T_PLUS;
    case '-':
      return T_MINUS;
    case '*':
      return T_MULTIPLY;
    case '/':
      return T_DIVIDE;
    case '(':
      return T_OPENPAREN;
    case ')':
      return T_CLOSEPAREN;
    case 'm':
      return T_MODULO;
    case EOF:
      return T_EOF;
    default:
      scanError(line, c);
      break;
	
    }
  }
  return T_EOF;//Won't ever get here. Makes compiler happy. 
}
// You need to fill this method with the appropriate code for it to work as described in the project description.
void Scanner::eatToken(Token toConsume) {
    // I am a placeholder. I'm not even fun. Change me into something that can actually consume tokens!
    // WRITEME
  //std::string s="";
  char c;
  switch(toConsume){
     case T_NEWLN:
       if(toConsume != T_NEWLN) mismatchError(line, toConsume, T_NEWLN);
       std::cin.get(c);
       break;
     case T_SEMICOLON:
       if(toConsume != T_SEMICOLON) mismatchError(line, toConsume, T_SEMICOLON);
       std::cin.get(c);
       break;
     case T_PLUS:
       if(toConsume != T_PLUS) mismatchError(line, toConsume, T_PLUS);
       std::cin.get(c);
       break;
     case T_MINUS:
       if(toConsume != T_MINUS) mismatchError(line, toConsume, T_MINUS);
       std::cin.get(c);
       break;
     case T_MULTIPLY:
       if(toConsume != T_MULTIPLY) mismatchError(line, toConsume, T_MULTIPLY);
       std::cin.get(c);
       break;
     case T_DIVIDE:
       if(toConsume != T_DIVIDE) mismatchError(line, toConsume, T_DIVIDE);
       std::cin.get(c);
       break;
     case T_OPENPAREN:
       if(toConsume != T_OPENPAREN) mismatchError(line, toConsume, T_OPENPAREN);
       std::cin.get(c);
       break;
     case T_CLOSEPAREN:
       if(toConsume != T_CLOSEPAREN) mismatchError(line, toConsume, T_CLOSEPAREN);
       std::cin.get(c);
       break;
     case T_MODULO:
       std::cin.get(c);
       if(c == 'm'){
	 std::cin.get(c);
	 if(c =='o'){
	   std::cin.get(c);
	   if(c=='d'){
	   }
	   else{
	     scanError(lineNumber(), c);
	     break;
	   }
	 }
	 else{
	   scanError(lineNumber(), c);
	   break;
	 }
       }
       else{
          scanError(lineNumber(), c);
	  break;
       }
       break;
     case T_NUMBER:
       if(toConsume != T_NUMBER) mismatchError(line, toConsume, T_NUMBER);
       /*
       std::cin.get(c);
       s.push_back(c);
       while(std::cin.peek()>='0' &&std::cin.peek()<='9'){
	 std::cin.get(c);
	 s.push_back(c);
       }
       value=stoi(s);*/
       break;
     case T_EOF:
       if(toConsume != T_EOF) mismatchError(line, toConsume, T_EOF);
       break;
  }
    
}
int Scanner::lineNumber() {
    return this->line;
}

int Scanner::getNumberValue() {
    return this->value;
}

// Parser implementation

// You may need to modify this constructor and make it do stuff, although it might not be neccessary.
Parser::Parser(bool eval) : evaluate(eval), output("") {
    // WRITEME
}

void Parser::checkBounds(long i){
    if (i<=INT_MAX && i>=INT_MIN){
        return;
    }
    else{
        if(evaluate == true){
	  outOfBoundsError(scanner.lineNumber(), i);
        }
    }
}
void Parser::divideZero(long l2, long val){
  if(evaluate==true){
    if(l2==0){
	 divideByZeroError(scanner.lineNumber(), val);
	 output="";
     }
  }
}
void Parser::parse() {
    start();
}

void Parser::match(Token t){
  if(lookAhead==t){
    //Newline tokens get skipped
    while(lookAhead==T_NEWLN){
      scanner.eatToken(t);
      lookAhead = scanner.nextToken();
     }

   scanner.eatToken(t);
   lookAhead = scanner.nextToken();

   //Newline tokens get skipped
   while(lookAhead==T_NEWLN){
      scanner.eatToken(t);
      lookAhead = scanner.nextToken();
     }
  }
  else{
    mismatchError(scanner.lineNumber(), t, lookAhead);
  }
}

void Parser::start() {
    // I am a placeholder. Implement a recursive descent parser starting from me. Add other methods for different recursive steps.
    // Depending on how you designed your grammar, how many levels of operator precedence you need, etc., you might end up with more
    // or less steps in the process.
    //
    // WRITEME
  E();
  if(evaluate==true){
    std::cout<<output;
  }
}
void Parser::E(){
  lookAhead=scanner.nextToken();
  long val=F();
  output+=std::to_string(val);
  E1();
}
long Parser::E1(){
  long val=0;
  long val2;
  switch(lookAhead){

  case(T_SEMICOLON):
       match(T_SEMICOLON);
       output+="\\n";
       val=F();
       checkBounds(val);
       output+=std::to_string(val);
       val2=E1();
       checkBounds(val2);
       return val2;
       break;
     case(T_EOF):
       break;
     default:
       parseError(scanner.lineNumber(),scanner.nextToken());
       break;
  }
  return val;
}
long Parser::F(){
  long val=G();
  return F1(val);
}
long Parser::F1(long val){
  long l1, l2, r1, r2;
  switch(lookAhead){
     case(T_PLUS):
       match(T_PLUS);
       l1 = G();
       checkBounds(l1);
       l1 = val+l1;
       checkBounds(l1);
       r1 = F1(l1);
       checkBounds(r1);
       return r1;
       break;
     case(T_MINUS):
       match(T_MINUS);
       l2 = G();
       checkBounds(l2);
       l2 = val-l2;
       checkBounds(l2);
       r2 = F1(l2);
       checkBounds(r2);
       return r2;
       break;
     case(T_SEMICOLON):
       return val;
       break;
     case(T_CLOSEPAREN):
       return val;
       break;
     case(T_EOF):
       return val;
       break;
     default:
       parseError(scanner.lineNumber(),scanner.nextToken());
       break;
  }
  return val;
}
long Parser::G(){
  long val=H();
  return G1(val);
}
long Parser::G1(long val){
  long l1, r1, l2, r2, l3, r3;
  switch(lookAhead){
     case(T_MULTIPLY):
       match(T_MULTIPLY);
       l1 = H();
       checkBounds(l1);
       l1=val*l1;
       checkBounds(l1);
       r1 = G1(l1);
       checkBounds(r1);
       return r1;
       break;
     case(T_DIVIDE):
       match(T_DIVIDE);
       l2 = H();
       divideZero(l2, val);
       checkBounds(l2);
       l2 = val/l2;
       checkBounds(l2);
       r2 = G1(l2);
       checkBounds(r2);
       return r2;
       break;
     case(T_MODULO):
       match(T_MODULO);
       l3 = H();
       checkBounds(l3);
       l3 = val%l3;
       checkBounds(l3);
       r3 = G1(l3);
       checkBounds(r3);
       return r3;
       break;
     case(T_SEMICOLON):
       return val;
       break;
     case(T_CLOSEPAREN):
       return val;
       break;
     case(T_PLUS):
       return val;
       break;
     case(T_MINUS):
       return val;
       break;
     case(T_EOF):
       return val;
       break;
     default:
       parseError(scanner.lineNumber(),scanner.nextToken());
       break;
  }
  return val;

}
long Parser::H(){
  long val=0;
  switch(lookAhead){
     case(T_OPENPAREN):
       match(T_OPENPAREN);
       val=F();
       checkBounds(val);
       match(T_CLOSEPAREN);
       return val;
       break;
     case(T_NUMBER):
       match(T_NUMBER);
       checkBounds(scanner.getNumberValue());
       return scanner.getNumberValue();
       break;      
       /*
    case(T_MULTIPLY):
       break;
     case(T_DIVIDE):
       break;
     case(T_MODULO):
       break;
     case(T_SEMICOLON):
       break;
     case(T_CLOSEPAREN):
       break;
     case(T_PLUS):
       break;
     case(T_MINUS):
        break;
       */
     case(T_EOF):
        return val;
        break;
     default:
       parseError(scanner.lineNumber(),scanner.nextToken());
       break;
  }
  return val;
}


// You will need to add more methods for this to work. Don't forget to also define them in calculator.hpp!
// WRITEME

