#include "typecheck.hpp"

// Defines the function used to throw type errors. The possible
// type errors are defined as an enumeration in the header file.
void typeError(TypeErrorCode code) {
  switch (code) {
    case undefined_variable:
      std::cerr << "Undefined variable." << std::endl;
      break;
    case undefined_method:
      std::cerr << "Method does not exist." << std::endl;
      break;
    case undefined_class:
      std::cerr << "Class does not exist." << std::endl;
      break;
    case undefined_member:
      std::cerr << "Class member does not exist." << std::endl;
      break;
    case not_object:
      std::cerr << "Variable is not an object." << std::endl;
      break;
    case expression_type_mismatch:
      std::cerr << "Expression types do not match." << std::endl;
      break;
    case argument_number_mismatch:
      std::cerr << "Method called with incorrect number of arguments." << std::endl;
      break;
    case argument_type_mismatch:
      std::cerr << "Method called with argument of incorrect type." << std::endl;
      break;
    case while_predicate_type_mismatch:
      std::cerr << "Predicate of while loop is not boolean." << std::endl;
      break;
    case do_while_predicate_type_mismatch:
      std::cerr << "Predicate of do while loop is not boolean." << std::endl;
      break;
    case if_predicate_type_mismatch:
      std::cerr << "Predicate of if statement is not boolean." << std::endl;
      break;
    case assignment_type_mismatch:
      std::cerr << "Left and right hand sides of assignment types mismatch." << std::endl;
      break;
    case return_type_mismatch:
      std::cerr << "Return statement type does not match declared return type." << std::endl;
      break;
    case constructor_returns_type:
      std::cerr << "Class constructor returns a value." << std::endl;
      break;
    case no_main_class:
      std::cerr << "The \"Main\" class was not exists." << std::endl;
      break;
    case main_class_members_present:
      std::cerr << "The \"Main\" class has members." << std::endl;
      break;
    case no_main_method:
      std::cerr << "The \"Main\" class does not have a \"main\" method." << std::endl;
      break;
    case main_method_incorrect_signature:
      std::cerr << "The \"main\" method of the \"Main\" class has an incorrect signature." << std::endl;
      break;
  }
  exit(1);
}

//memberVariable is used to keep track of if a declaration is for a member
//variable(true) or a local variable(false). Used in visitDeclarationNode
//to add the right offsets
bool memberVariable;

// TypeCheck Visitor Functions: These are the functions you will
// complete to build the symbol table and type check the program.
// Not all functions must have code, many may be left empty.

void TypeCheck::visitProgramNode(ProgramNode* node) {
  classTable=new ClassTable();
  for(std::list<ClassNode*>::iterator i=node->class_list->begin(); i!=node->class_list->end(); i++){
    visitClassNode(*i);
  }
  if(classTable->count("Main")<=0){
    typeError(no_main_class);
  }
  for(ClassTable::const_iterator i=classTable->begin(); i!=classTable->end(); i++){
    if(i->first.compare("Main")==0){
      if(i->second.members->size()>0){
        typeError(main_class_members_present);
      }
      
      if(i->second.methods->count("main")<=0){
        typeError(no_main_method);
      }
      else{
        if(i->second.methods->find("main")->second.returnType.baseType != bt_none){
          typeError(main_method_incorrect_signature);
        } 
      }
    }
  }
}

void TypeCheck::visitClassNode(ClassNode* node) {
  ClassInfo classinfo;
  currentClassName=node->identifier_1->name;
  
  IdentifierNode* superclass=node->identifier_2;
  if(superclass!=0){
    if(classTable->count(superclass->name)>0){
      classinfo.superClassName = superclass->name;
    }
    else{
      typeError(undefined_class);
    }
    
  }
  else{
    classinfo.superClassName="";
  }
  
  currentMethodTable=new MethodTable();
  currentVariableTable=new VariableTable();
  currentMemberOffset=0;
  currentLocalOffset=0;


  std::string currentSuper = classinfo.superClassName;
  if(currentSuper!=""){
    while(currentSuper!=""){
      ClassInfo superClassInfo=classTable->find(currentSuper)->second;
      for(VariableTable::const_iterator i=superClassInfo.members->begin(); i!=superClassInfo.members->end(); i++){
        if(currentVariableTable->count(i->first)<=0){
          VariableInfo variableInfo=i->second;
          variableInfo.offset=currentMemberOffset;
          currentMemberOffset+=4;
          currentVariableTable->insert(std::pair<std::string, VariableInfo>(i->first,variableInfo));
        }
      }
      currentSuper=superClassInfo.superClassName;
    }
  }
  
  

  for(std::list<DeclarationNode*>::iterator i=node->declaration_list->begin(); i!=node->declaration_list->end(); i++){
    visitDeclarationNode(*i);
  }


  classinfo.members=currentVariableTable;
  classinfo.membersSize=currentVariableTable->size()*4;
  classTable->insert(std::pair<std::string, ClassInfo>(node->identifier_1->name,classinfo));

  for(std::list<MethodNode*>::iterator i=node->method_list->begin(); i!= node->method_list->end(); i++){
    visitMethodNode(*i);
    
    classinfo.methods=currentMethodTable;
    std::map<std::string, ClassInfo>::iterator it1 = classTable->find(currentClassName);
    if(it1!=classTable->end()){
      it1->second=classinfo;
    } 
  }

  classinfo.methods = currentMethodTable;
  std::map<std::string, ClassInfo>::iterator it = classTable->find(currentClassName);
  if(it!=classTable->end()){
    it->second = classinfo;
  } 
}

void TypeCheck::visitMethodNode(MethodNode* node) { 
  CompoundType type;
  MethodInfo methodinfo;
  node->type->accept(this);
  type.baseType = node->type->basetype;
  type.objectClassName = node->type->objectClassName;
  methodinfo.returnType = type;

  if(node->identifier->name.compare(currentClassName) == 0 && methodinfo.returnType.baseType != bt_none){
    typeError(constructor_returns_type);
  }

  std::list<CompoundType>* params=new std::list<CompoundType>();
  currentVariableTable = new VariableTable(); 
  currentParameterOffset = 12;
  for(std::list<ParameterNode*>::iterator it = node->parameter_list->begin(); it != node->parameter_list->end(); ++it){
    CompoundType cType;
    (*it)->type->accept(this);
    cType.baseType = (*it)->type->basetype;
    cType.objectClassName = (*it)->type->objectClassName;
    params->push_back(cType);

    VariableInfo info;
    info.type = cType;
    info.size = 4;
    info.offset = currentParameterOffset;
    currentParameterOffset += 4;
    currentVariableTable->insert(std::pair<std::string, VariableInfo>((*it)->identifier->name,info));
  }
  methodinfo.parameters = params;
  
  visitMethodBodyNode(node->methodbody);

  //typecheck method return matches return type of method
  
  if(node->type->basetype == bt_none && node->methodbody->returnstatement != 0){
    typeError(return_type_mismatch);
  }
  if(node->type->basetype != bt_none && node->methodbody->returnstatement == 0){
    typeError(return_type_mismatch);
  }

  if(node->type->basetype != bt_none && node->type->basetype != node->methodbody->basetype){
    typeError(return_type_mismatch);
  }

  if(node->type->basetype == bt_object && node->type->objectClassName != node->methodbody->objectClassName){
    std::string superClName = classTable->find(node->methodbody->objectClassName)->second.superClassName;
    while(superClName != "" ){
      if(superClName != node->type->objectClassName){
        superClName = classTable->find(superClName)->second.superClassName;
      }
      else{
        break;
      }
    }
    if(superClName != node->type->objectClassName){
      typeError(return_type_mismatch);
    }
  }
  methodinfo.variables = currentVariableTable;
  methodinfo.localsSize = currentLocalOffset*(-1)-4;
  currentMethodTable->insert(std::pair<std::string, MethodInfo>(node->identifier->name,methodinfo));
}

void TypeCheck::visitMethodBodyNode(MethodBodyNode* node) {
  currentLocalOffset = -4;
  for(std::list<DeclarationNode*>::iterator it = node->declaration_list->begin(); it != node->declaration_list->end(); ++it){
    visitDeclarationNode(*it);
  }

  //typechecking
  for(std::list<StatementNode*>::iterator it = node->statement_list->begin(); it != node->statement_list->end(); ++it){
    (*it)->accept(this);
  }
  
  if(node->returnstatement != 0){
    visitReturnStatementNode(node->returnstatement);
    node->basetype = node->returnstatement->basetype;
    if(node->returnstatement->basetype == bt_object){
      node->objectClassName = node->returnstatement->objectClassName;
    }
  }
 
}

void TypeCheck::visitParameterNode(ParameterNode* node) {
  // WRITEME: Replace with code if necessary
}

void TypeCheck::visitDeclarationNode(DeclarationNode* node) {
  for(std::list<IdentifierNode*>::iterator it = node->identifier_list->begin(); it != node->identifier_list->end(); ++it){
    VariableInfo variableinfo;
    
    CompoundType type;
    node->type->accept(this);
    type.baseType = node->type->basetype;
    type.objectClassName = node->type->objectClassName;

    //typechecking
    if(type.baseType == bt_object){
      if(classTable->count(type.objectClassName)<=0){
        typeError(undefined_class);
      }
    }
    
    variableinfo.type = type;
    variableinfo.size = 4;
    if(currentLocalOffset != 0){
      variableinfo.offset = currentLocalOffset;
      currentLocalOffset -= 4;
    }
    else{
      variableinfo.offset = currentMemberOffset;
      currentMemberOffset += 4;
    }

    //currentVariableTable->insert(std::pair<std::string, VariableInfo>((*it)->name,variableinfo));
    (*currentVariableTable)[(*it)->name] = variableinfo;

  }
}

void TypeCheck::visitReturnStatementNode(ReturnStatementNode* node) {
  node->visit_children(this);
  node->basetype=node->expression->basetype;
  node->objectClassName=node->expression->objectClassName;
}

void TypeCheck::visitAssignmentNode(AssignmentNode* node) {
  node->visit_children(this);
  VariableTable* variableTable;
  ClassInfo classInfo;
  bool exists=false;
  std::string className;
  std::string super;
  std::map<std::basic_string<char>, ClassInfo>::iterator class_iter;
  std::map<std::basic_string<char>, VariableInfo>::iterator variable_iter;
  VariableInfo variableInfo;

  if(node->identifier_2==NULL){
    //Format: identifier1=Expression
    if(currentVariableTable->find(node->identifier_1->name)!=currentVariableTable->end()){
      //exists the variable in the local variable table
      node->basetype=(*currentVariableTable)[node->identifier_1->name].type.baseType;
      node->objectClassName=(*currentVariableTable)[node->identifier_1->name].type.objectClassName;
    }
    else{
      //Search member variables
      className=currentClassName;
      while(!exists){
        if(classTable->find(className)!=classTable->end()){
          //Found the class
          variableTable=(*classTable)[className].members;
          className=(*classTable)[className].superClassName;
          if(variableTable->find(node->identifier_1->name)!=variableTable->end()){
            node->basetype=(*variableTable)[node->identifier_1->name].type.baseType;
	    node->objectClassName=(*variableTable)[node->identifier_1->name].type.objectClassName;
            exists=true;
          }
        }
        else{
          typeError(undefined_variable);
        }
      }
    }
  }
  else{
    //Format: identifier1.identifier2=Expression
    if(currentVariableTable->find(node->identifier_1->name)!=currentVariableTable->end()){
      //Found identifier1 in local Variable table
      className=(*currentVariableTable)[node->identifier_1->name].type.objectClassName;
      if(classTable->find(className)!=classTable->end()){
        //Found the class of identifier1
        variableTable=(*classTable)[className].members;
        if(variableTable->find(node->identifier_2->name)!=variableTable->end()){
          //identifier1 has a member identifier2
          node->basetype=(*variableTable)[node->identifier_2->name].type.baseType;
	  node->objectClassName=(*variableTable)[node->identifier_2->name].type.objectClassName;
        }
        else{
          //cannot find identifier2, check superclass.
          className=(*classTable)[className].superClassName;
          while(!exists){
            if(classTable->find(className)!=classTable->end()){
              variableTable=(*classTable)[className].members;
              className=(*classTable)[className].superClassName;
              if(variableTable->find(node->identifier_2->name)!=variableTable->end()){
                //found it
                node->basetype=(*variableTable)[node->identifier_2->name].type.baseType;
		node->objectClassName=(*variableTable)[node->identifier_2->name].type.objectClassName;
                exists=true;
              }
            }
            else{
              //did not find it
              typeError(undefined_member);
            }
          }
          if(!exists){
            typeError(undefined_member);
          }
        }
      }
      else{
        typeError(not_object);
      }

    }
    else{
      //Did not find identifier1 in local variable table, check member variables
      className=currentClassName;
      if(classTable->find(className)!=classTable->end()){
	while(!exists){
          class_iter=classTable->find(className);
          if(class_iter!=classTable->end()){
            classInfo=class_iter->second;
            variableTable=classInfo.members;
            variable_iter=variableTable->find(node->identifier_1->name);
            //If no more Super classes to check, throw undefined_member
            if(className==""){
              typeError(undefined_variable);
            }
            //Go to Super class if searched all variables
            if(variable_iter==variableTable->end()){
              className=classInfo.superClassName;
            }
            //It exists in this class!
            else{
              exists=true;
              variableInfo=variable_iter->second;
              node->basetype=variableInfo.type.baseType;
              node->objectClassName=variableInfo.type.objectClassName;
            }
          }
          else{
            typeError(undefined_variable);
          }
        }
	className=(*variableTable)[node->identifier_1->name].type.objectClassName;
	if(classTable->find(className)!=classTable->end()){
	  variableTable=(*classTable)[className].members;
	  if(variableTable->find(node->identifier_2->name)!=variableTable->end()){
	    //Identifier2 is member is member of class of type Identifier2
	    node->basetype =(*variableTable)[node->identifier_2->name].type.baseType;
	    node->objectClassName=variableInfo.type.objectClassName;
	  }
	  else{
	    //Check superclasses to find member variable with identifier2 as name
	    className=(*classTable)[className].superClassName;
	    bool exists2=false;
	    while(!exists2){
	      if(classTable->find(className)!=classTable->end()){
		variableTable=(*classTable)[className].members;
		if(variableTable->find(node->identifier_2->name) != variableTable->end()){
		  node->basetype=(*variableTable)[node->identifier_2->name].type.baseType;
		  node->objectClassName=(*variableTable)[node->identifier_2->name].type.objectClassName;
		  exists2=true;
		  break;
		}
		className=(*classTable)[className].superClassName;
	      }
	      else{
		typeError(undefined_member);
	      }
	    }
	  }
	}
	else{
	  typeError(not_object);
	}
      }
      else{
	typeError(not_object);
      }
    }
 
  }

  //Checks to see if the variable on left side has same type as right side.
  if(node->basetype != node->expression->basetype){
    typeError(assignment_type_mismatch);
  }
    
}

void TypeCheck::visitCallNode(CallNode* node) {
  node->visit_children(this);
  node->basetype=node->methodcall->basetype;
  node->objectClassName=node->methodcall->objectClassName;
}

void TypeCheck::visitIfElseNode(IfElseNode* node) {
  node->visit_children(this);
  if(node->expression->basetype!=bt_boolean){
    typeError(if_predicate_type_mismatch);
  }
  node->basetype=bt_boolean;
}

void TypeCheck::visitWhileNode(WhileNode* node) {
  node->visit_children(this);
  if(node->expression->basetype!=bt_boolean){
    typeError(while_predicate_type_mismatch);
  }
  node->basetype=bt_boolean;
}

void TypeCheck::visitDoWhileNode(DoWhileNode* node) {
  node->visit_children(this);
  if(node->expression->basetype!=bt_boolean){
    typeError(do_while_predicate_type_mismatch);
  }
  node->basetype=bt_boolean;
}

void TypeCheck::visitPrintNode(PrintNode* node) {
  node->visit_children(this);
}

void TypeCheck::visitPlusNode(PlusNode* node) {
  node->visit_children(this);
  if(node->expression_1->basetype!=bt_integer||node->expression_2->basetype!=bt_integer) {
    typeError(expression_type_mismatch);
  }
  node->basetype=bt_integer;
}

void TypeCheck::visitMinusNode(MinusNode* node) {
  node->visit_children(this);
  if(node->expression_1->basetype!=bt_integer||node->expression_2->basetype!=bt_integer) {
    typeError(expression_type_mismatch);
  }
  node->basetype=bt_integer;
}

void TypeCheck::visitTimesNode(TimesNode* node) {
  node->visit_children(this);
  if(node->expression_1->basetype!=bt_integer||node->expression_2->basetype!=bt_integer) {
    typeError(expression_type_mismatch);
  }
  node->basetype=bt_integer;
}

void TypeCheck::visitDivideNode(DivideNode* node) {
    node->visit_children(this);
    if(node->expression_1->basetype!=bt_integer||node->expression_2->basetype!=bt_integer) {
        typeError(expression_type_mismatch);
    }
    node->basetype=bt_integer;
}

void TypeCheck::visitGreaterNode(GreaterNode* node) {
  node->visit_children(this);
  if(node->expression_1->basetype!=bt_integer||node->expression_2->basetype!=bt_integer) {
    typeError(expression_type_mismatch);
  }
  node->basetype=bt_boolean;
}

void TypeCheck::visitGreaterEqualNode(GreaterEqualNode* node) {
  node->visit_children(this);
  if(node->expression_1->basetype!=bt_integer||node->expression_2->basetype!=bt_integer) {
    typeError(expression_type_mismatch);
  }
  node->basetype=bt_boolean;
}

void TypeCheck::visitEqualNode(EqualNode* node) {
  node->visit_children(this);
  if(node->expression_1->basetype!=node->expression_2->basetype){
    typeError(expression_type_mismatch);
  }
  node->basetype=bt_boolean;
}

void TypeCheck::visitAndNode(AndNode* node) {
  node->visit_children(this);
  if (node->expression_1->basetype!=bt_boolean||node->expression_2->basetype!=bt_boolean) {
    typeError(expression_type_mismatch);
  }
  node->basetype=bt_boolean;
}

void TypeCheck::visitOrNode(OrNode* node) {
  node->visit_children(this);
  if (node->expression_1->basetype!=bt_boolean||node->expression_2->basetype!=bt_boolean) {
    typeError(expression_type_mismatch);
  }
  node->basetype=bt_boolean;
}

void TypeCheck::visitNotNode(NotNode* node) {
  node->visit_children(this);
  if(node->expression->basetype!=bt_boolean){
    typeError(expression_type_mismatch);
  }
  node->basetype=bt_boolean;
}

void TypeCheck::visitNegationNode(NegationNode* node) {
  node->visit_children(this);
  if(node->expression->basetype!=bt_integer){
    typeError(expression_type_mismatch);
  }
  node->basetype=bt_integer;
}

void TypeCheck::visitMethodCallNode(MethodCallNode* node) {
  node->visit_children(this);
  ClassInfo classInfo;
  MethodInfo methodInfo;
  VariableInfo variableInfo; 
  MethodTable* methodTable; 
  VariableTable* variableTable; 
  std::string super; 
  bool exists=false;
  std::map<std::basic_string<char>, ClassInfo>::iterator class_iter, superclass_iter;
  std::map<std::basic_string<char>, MethodInfo>::iterator method_iter, supermethod_iter;
  std::map<std::basic_string<char>, VariableInfo>::iterator variable_iter;
  std::list<CompoundType>::iterator type_iter;
  std::list<ExpressionNode*>::iterator expression_iter;
    
   
  if(node->identifier_2!=NULL){ 
    //If the method is being called like: 'identifier_1.identifier_2()':
    if(currentVariableTable->find(node->identifier_1->name)!=currentVariableTable->end()){ 
      //Find the variable that is calling the method in the VariableTable
      if(node->identifier_1->objectClassName==currentClassName){ 
	//If the class of the variable is of type currentClass, search for the method
	if(currentMethodTable->find(node->identifier_2->name)!=currentMethodTable->end()){
	  //If the method is in the currentMethodTable check if the number of parameters is correct
	  methodInfo=(currentMethodTable->find(node->identifier_2->name))->second;
	  type_iter=methodInfo.parameters->begin(); 
	  expression_iter=node->expression_list->begin();
	  if(node->expression_list->size()!=methodInfo.parameters->size()){ 
	    typeError(argument_number_mismatch); 
	  }
	  while(type_iter!=methodInfo.parameters->end() && expression_iter!=node->expression_list->end()){
	    //If the types are not the correct types for the method, throw an error
	    if(type_iter->baseType!=(*expression_iter)->basetype){
	      typeError(argument_type_mismatch);
	    }
	    type_iter++; 
	    expression_iter++;
	  }
	  node->basetype=methodInfo.returnType.baseType;
	  node->objectClassName=methodInfo.returnType.objectClassName;         
	}
	else{
	  //If the method is not in the currentMethodTable check the super class
	  if(currentVariableTable->find(node->identifier_1->name)!=currentVariableTable->end()){
	    super=currentVariableTable->find(node->identifier_1->name)->second.type.objectClassName;
	    if(classTable->find(super)!=classTable->end()){
	      //Loop through super classes
	      while(!exists){
		//If you run out of classes, there is no method
		if(super==""){
		  //typeError(undefined_method);
		}
		if(classTable->find(super)!=classTable->end()){
		  //If you the superclass, see if that superclass has the method
		  methodTable=classTable->find(super)->second.methods;
		  if(methodTable->find(node->identifier_2->name)==methodTable->end()){
		    //If you've searched through all methods of class, move to next one
		    class_iter=classTable->find(super);
		    super=class_iter->second.superClassName;
		  }
		  else{
		    //If you exists it, check if number of params/types are correct
		    //methodInfo=methodTable->find(node->identifier_2->name)->second;
		    //if(node->expression_list != NULL && methodInfo.parameters != NULL){
		    methodInfo=methodTable->find(node->identifier_2->name)->second;
		    type_iter=methodInfo.parameters->begin();
		    expression_iter=node->expression_list->begin();
		    if(node->expression_list->size()!=methodInfo.parameters->size()){ 
		      typeError(argument_number_mismatch); 
		    }
		    while(type_iter!=methodInfo.parameters->end() && expression_iter!=node->expression_list->end()){
		      //If the types are not the correct types for the method, throw an error
		      if(type_iter->baseType!=(*expression_iter)->basetype){
			typeError(argument_type_mismatch);
		      }
		      type_iter++; 
		      expression_iter++;
		    }
		    exists=true;
		    node->basetype=methodInfo.returnType.baseType;
		    node->objectClassName=methodInfo.returnType.objectClassName;   
		  }
		}
	      }
	    }
	  }
	}
      }
      else{
	//The variable is not of memberVariable of this class, find its class
	if(currentVariableTable->find(node->identifier_1->name)!=currentVariableTable->end()){
	  variableInfo=currentVariableTable->find(node->identifier_1->name)->second;
	  if(classTable->find(variableInfo.type.objectClassName)!=classTable->end()){
	    //If its class exists, check the methods
	    classInfo=classTable->find(variableInfo.type.objectClassName)->second;
	    methodTable=classInfo.methods;
	    if(methodTable->find(node->identifier_2->name)!=methodTable->end()){
	      //If the method exists, check params/types
	      methodInfo=methodTable->find(node->identifier_2->name)->second;
	      type_iter=methodInfo.parameters->begin();
	      expression_iter=node->expression_list->begin();
	      if(methodInfo.parameters->size()!=node->expression_list->size()){
		typeError(argument_number_mismatch);
	      }
	      while(type_iter!=methodInfo.parameters->end() && expression_iter!=node->expression_list->end()){
		//If the types are not the correct types for the method, throw an error
		if(type_iter->baseType!=(*expression_iter)->basetype){
		  typeError(argument_type_mismatch);
		}
		type_iter++; 
		expression_iter++;
	      }
                    
	      node->basetype=methodInfo.returnType.baseType;
	      node->objectClassName=methodInfo.returnType.objectClassName;   
	    }
	    else{
	      //If you didn't find the method, check superClasses
	      super=classInfo.superClassName;
	      class_iter=classTable->find(super);
	      if(class_iter!=classTable->end()){
		while(!exists){
		  classInfo = class_iter->second;
		  if(super==""){
		    //typeError(undefined_method);
		  }
		  methodTable=classInfo.methods;
		  method_iter=methodTable->find(node->identifier_2->name);
		  if(method_iter==methodTable->end()){
		    class_iter=classTable->find(super);
		    super=classInfo.superClassName;
		  }
		  else{
		    methodInfo=method_iter->second;
		    type_iter=methodInfo.parameters->begin();
		    expression_iter=node->expression_list->begin();
		    if(methodInfo.parameters->size()!=node->expression_list->size()){
		      typeError(argument_number_mismatch);
		    }
		    while(type_iter!=methodInfo.parameters->end() && expression_iter!=node->expression_list->end()){
		      //If the types are not the correct types for the method, throw an error
		      if(type_iter->baseType!=(*expression_iter)->basetype){
			typeError(argument_type_mismatch);
		      }
		      type_iter++; 
		      expression_iter++;
		    }
		    node->basetype = methodInfo.returnType.baseType;
		    node->objectClassName=methodInfo.returnType.objectClassName;   
		    exists=true;
		  }
		}
	      }
	      else{
		//typeError(undefined_method);
	      }
	    }
	  }
	  else{
	    typeError(not_object);
	  }
	}
      }
    }
    else{
      //The variable does not exist in local variables. Search member variables.
      class_iter=classTable->find(currentClassName);
      if(class_iter!=classTable->end()){
	//exists the currentClass in the table
	classInfo=class_iter->second;
	variableTable=classInfo.members;
	variable_iter=variableTable->find(node->identifier_1->name);
	if(variable_iter!=variableTable->end()){
	  //the variable exists in the member list of the class
	  class_iter=classTable->find(variable_iter->second.type.objectClassName);
	  if(class_iter!=classTable->end()){
	    //The class of the variable is in the table.
	    classInfo=class_iter->second;
	    methodTable=classInfo.methods;
	    method_iter=methodTable->find(node->identifier_2->name);
	    if(method_iter!=methodTable->end()){
	      //The method is in the method table of the class
	      methodInfo = method_iter->second;
	      type_iter=methodInfo.parameters->begin();
	      expression_iter=node->expression_list->begin();
	      if(methodInfo.parameters->size()!=node->expression_list->size()){
		typeError(argument_number_mismatch);
	      }
	      while(type_iter!=methodInfo.parameters->end() && expression_iter!=node->expression_list->end()){
		//If the types are not the correct types for the method, throw an error
		if(type_iter->baseType!=(*expression_iter)->basetype){
		  typeError(argument_type_mismatch);
		}
		type_iter++; 
		expression_iter++;
	      }
	      node->basetype=methodInfo.returnType.baseType;
	      node->objectClassName=methodInfo.returnType.objectClassName;   
	    }
	    else{
	      //Method not in current method table, look to super method table;
	      variableTable=(*classTable)[currentClassName].members;
	      super=(*variableTable)[node->identifier_1->name].type.objectClassName;
	      class_iter=classTable->find(super);
	      if(class_iter!=classTable->end()){
		while(!exists){
		  classInfo=class_iter->second;
		  if(super==""){
		    // typeError(undefined_method);
		  }
		  methodTable=classInfo.methods;
		  method_iter=methodTable->find(node->identifier_2->name);
		  if(method_iter==methodTable->end()){
		    class_iter=classTable->find(super);
		    super=classInfo.superClassName;
		  }
		  else{
		    methodInfo=method_iter->second;
		    type_iter=methodInfo.parameters->begin();
		    expression_iter=node->expression_list->begin();
		    if(methodInfo.parameters->size() != node->expression_list->size()){
		      typeError(argument_number_mismatch);
		    }
		    while(type_iter!=methodInfo.parameters->end() && expression_iter!=node->expression_list->end()){
		      //If the types are not the correct types for the method, throw an error
		      if(type_iter->baseType!=(*expression_iter)->basetype){
			typeError(argument_type_mismatch);
		      }
		      type_iter++; 
		      expression_iter++;
		    }
		    node->basetype=methodInfo.returnType.baseType;
		    node->objectClassName=methodInfo.returnType.objectClassName;   
		    exists = true;
		  }
		}
	      }
	    }
	  }
	  else{
	    //Member is not an object (its a boolean or integer)
	    typeError(not_object);
	  }
	}
	else{
	     super=classInfo.superClassName;
	     while(!exists){
	       class_iter=classTable->find(super);
	       if(class_iter!=classTable->end()){
		 classInfo=class_iter->second;
		 variableTable=classInfo.members;
		 variable_iter=variableTable->find(node->identifier_1->name);
		 //If no more Super classes to check, throw undefined_member
		 if(super== ""){
		   typeError(undefined_variable);
		 }
		 //Go to Super class if searched all variables
		 if(variable_iter==variableTable->end()){
		   super=classInfo.superClassName;
		 }
		 //It exists in this class!
		 else{
		   exists=true;
		 }
	       }
	       else{
		 typeError(undefined_variable);
	       }
	     }
	       class_iter=classTable->find(variable_iter->second.type.objectClassName);
	       if(class_iter!=classTable->end()){
		 //The class of the variable is in the table.
		 classInfo=class_iter->second;
		 methodTable=classInfo.methods;
		 method_iter=methodTable->find(node->identifier_2->name);
		 if(method_iter!=methodTable->end()){
		   //The method is in the method table of the class
		   methodInfo = method_iter->second;
		   type_iter=methodInfo.parameters->begin();
		   expression_iter=node->expression_list->begin();
		   if(methodInfo.parameters->size()!=node->expression_list->size()){
		     typeError(argument_number_mismatch);
		   }
		   while(type_iter!=methodInfo.parameters->end() && expression_iter!=node->expression_list->end()){
		     //If the types are not the correct types for the method, throw an error
		     if(type_iter->baseType!=(*expression_iter)->basetype){
		       typeError(argument_type_mismatch);
		     }
		     type_iter++; 
		     expression_iter++;
		   }
		   node->basetype=methodInfo.returnType.baseType;
		   node->objectClassName=methodInfo.returnType.objectClassName;   
		 }
		 else{
		   //Method not in current method table, look to super method table;
		   variableTable=(*classTable)[currentClassName].members;
		   super=(*variableTable)[node->identifier_1->name].type.objectClassName;
		   class_iter=classTable->find(super);
		   if(class_iter!=classTable->end()){
		     while(!exists){
		       classInfo=class_iter->second;
		       if(super==""){
			 //typeError(undefined_method);
		       }
		       methodTable=classInfo.methods;
		       method_iter=methodTable->find(node->identifier_2->name);
		       if(method_iter==methodTable->end()){
			 class_iter=classTable->find(super);
			 super=classInfo.superClassName;
		       }
		       else{
			 methodInfo=method_iter->second;
			 type_iter=methodInfo.parameters->begin();
			 expression_iter=node->expression_list->begin();
			 if(methodInfo.parameters->size() != node->expression_list->size()){
			   typeError(argument_number_mismatch);
			 }
			 while(type_iter!=methodInfo.parameters->end() && expression_iter!=node->expression_list->end()){
			   //If the types are not the correct types for the method, throw an error
			   if(type_iter->baseType!=(*expression_iter)->basetype){
			     typeError(argument_type_mismatch);
			   }
			   type_iter++; 
			   expression_iter++;
			 }
			 node->basetype=methodInfo.returnType.baseType;
			 node->objectClassName=methodInfo.returnType.objectClassName;   
			 exists = true;
		       }
		     }
		   }
		 }
	       }
	       else{
		 //Member is not an object (its a boolean or integer)
		 typeError(not_object);
	       }
	     
	     }
      } 
    }
  }
  else{
    //Method call is like: 'identifier1()'
    method_iter=currentMethodTable->find(node->identifier_1->name);
    if(method_iter!=currentMethodTable->end()){
      //method is in currentClass
      methodInfo=method_iter->second;
      if(methodInfo.parameters != NULL && node->expression_list != NULL){
	type_iter=methodInfo.parameters->begin();
	expression_iter=node->expression_list->begin();

       if(methodInfo.parameters->size()!=node->expression_list->size()){
	  typeError(argument_number_mismatch);
	}
	while(type_iter!=methodInfo.parameters->end() && expression_iter!=node->expression_list->end()){
	  //If the types are not the correct types for the method, throw an error
	  if(type_iter->baseType!=(*expression_iter)->basetype){
	    typeError(argument_type_mismatch);
	  }
	  type_iter++; 
	  expression_iter++;
	}
	node->basetype=methodInfo.returnType.baseType;
        node->objectClassName=methodInfo.returnType.objectClassName;   
      }
    }
    else{
      //Check superclass for method
      class_iter=classTable->find(currentClassName);
      if(class_iter!=classTable->end()){
	while(!exists){
	  classInfo=class_iter->second;
	  super=classInfo.superClassName;
	  if(super==""){
	    //typeError(undefined_method);
	  }
	  methodTable=classInfo.methods;
	  method_iter=methodTable->find(node->identifier_1->name);
	  if(method_iter!=methodTable->end()){
	    methodInfo=method_iter->second;
	    type_iter=methodInfo.parameters->begin();
	    expression_iter=node->expression_list->begin();
	    if(methodInfo.parameters->size()!=node->expression_list->size()){
	      typeError(argument_number_mismatch);
	    }
	    while(type_iter!=methodInfo.parameters->end() && expression_iter!=node->expression_list->end()){
	      //If the types are not the correct types for the method, throw an error
	      if(type_iter->baseType!=(*expression_iter)->basetype){
		typeError(argument_type_mismatch);
	      }
	      type_iter++; 
	      expression_iter++;
	    }
	    node->basetype=methodInfo.returnType.baseType;
	    node->objectClassName=methodInfo.returnType.objectClassName;   
	    exists=true;
	  }
	  else{
	    class_iter=classTable->find(super);
	  }
	}
      }
    }
  }  
}
 

        
  

void TypeCheck::visitMemberAccessNode(MemberAccessNode* node) {
  node->visit_children(this);
  std::map<std::string, VariableInfo>::iterator variable_iter=currentVariableTable->find(node->identifier_1->name);
  std::map<std::string, ClassInfo>::iterator class_iter;
  VariableTable* variableTable;
  VariableTable* classVariableTable; 
  ClassInfo classInfo;
  VariableInfo variableInfo;
  std::string variableClassName, className, super;
  bool exists=false;
 
  //Start of Block 1
  //Deals with the case: variable1 in 'variable1.variable2' exists in local variableTable
  if(variable_iter!=currentVariableTable->end()){
    //variable1 exists in 'variable1.variable2.' It's a local variable look for variable2 in member variables of variable1.
    variableInfo=variable_iter->second;
    variableClassName=variableInfo.type.objectClassName;
    class_iter=classTable->find(variableClassName);
    if(class_iter!=classTable->end()){
    //exists class in which variable1 is a type of
      classInfo=class_iter->second;
      classVariableTable=classInfo.members;
      variable_iter=classVariableTable->find(node->identifier_2->name);
      if(variable_iter!=classVariableTable->end()){
        //If variable2 is a member of variable1, get it
        variableInfo=variable_iter->second;
        node->basetype=variableInfo.type.baseType;
        node->objectClassName=variableInfo.type.objectClassName;
      }
      else{
        //If variable2 is not a member of variable1, check superclass.
        variableClassName=classInfo.superClassName;
        while(!exists){
          class_iter=classTable->find(variableClassName);
          if(class_iter!=classTable->end()){
            classInfo=class_iter->second;
            classVariableTable=classInfo.members;
            variable_iter=classVariableTable->find(node->identifier_2->name);
            //If no more Super classes to check, throw undefined_member
            if(variableClassName== ""){
              typeError(undefined_member);
            }
            //Go to Super class if searched all variables
            if(variable_iter==classVariableTable->end()){
              variableClassName=classInfo.superClassName;
            }
            //It exists in this class!
            else{
              exists=true;
              variableInfo=variable_iter->second;
              node->basetype=variableInfo.type.baseType;
              node->objectClassName=variableInfo.type.objectClassName;
            }
          }
          else{
            typeError(undefined_member);
          }
        }
      }
    }
    //If can't find class to which variable1 belongs do, object does not exist
    else{
      typeError(not_object); 
    }
  }
  //End of Block1
  
  //Start of Block2
  //Deals with the case: If variable1 of 'variable1.variable2' was not in the local variables, check members of class
  else{
    class_iter=classTable->find(currentClassName);
    if(class_iter!=classTable->end()){
      //exists our current class
      classInfo=class_iter->second;
      classVariableTable=classInfo.members;
      variable_iter=classVariableTable->find(node->identifier_1->name);
      if(variable_iter!=classVariableTable->end()){
        //exists variable1 in member list, check for variable2
        variableInfo=variable_iter->second;
        variableClassName=variableInfo.type.objectClassName;
        class_iter=classTable->find(variableClassName);
        if(class_iter!=classTable->end()){
        //exists our current class
          classInfo=class_iter->second;
          classVariableTable=classInfo.members;
          variable_iter=classVariableTable->find(node->identifier_2->name);
          if(variable_iter==classVariableTable->end()){
             //Variable2 not member of current class, check super class. 
            variableClassName=classInfo.superClassName;
            while(!exists){
              class_iter=classTable->find(variableClassName);
              if(class_iter!=classTable->end()){
                //exists superClass
                classInfo=class_iter->second;
                classVariableTable=classInfo.members;
                variable_iter=classVariableTable->find(node->identifier_2->name);
                if(variableClassName==""){
                  //No more super classes, could not find member
                  typeError(undefined_member);
                }
                if(variable_iter==classVariableTable->end()){
                  // Not in current superclass
                  variableClassName=classInfo.superClassName;
                }
                else{
                  variableInfo=variable_iter->second;
                  node->objectClassName=variableInfo.type.objectClassName;
                  node->basetype=variableInfo.type.baseType;
                  exists=true;
                }
              }
            }
          }
          else{
            //Variable2 is member of class
            variableInfo=variable_iter->second;
            node->objectClassName=variableInfo.type.objectClassName;
            node->basetype=variableInfo.type.baseType;
          }
        }
        else{
          typeError(undefined_class); 
        }
      }
      else{
        //Did not find member in current class. Check Super class
        super=classInfo.superClassName;
        while(super!=""){
          if(classTable->find(super) != classTable->end()){
            classInfo=classTable->find(super)->second;
            variableTable=classInfo.members;
            if(variableTable->find(node->identifier_1->name)!=variableTable->end()){
              //If we find the member in the current class, check variable2
              variableInfo=variableTable->find(node->identifier_1->name)->second;
              if(classTable->find(variableInfo.type.objectClassName)!=classTable->end()){
                classInfo=classTable->find(variableInfo.type.objectClassName)->second;
                super=variableInfo.type.objectClassName;
                while(!exists && super!= ""){
                  if(classTable->find(super)!=classTable->end()){
                    classInfo=classTable->find(super)->second;
                    variableTable=classInfo.members;
                    if(variableTable->find(node->identifier_2->name)!=variableTable->end()){
                      exists=true;
                      variableInfo=variableTable->find(node->identifier_2->name)->second;
                      node->basetype=variableInfo.type.baseType;
                      node->objectClassName=variableInfo.type.objectClassName;
                      break;
                    }
                    else{
                      super=classInfo.superClassName;
                    }
                  }
                  else{
                    typeError(not_object);
                  }
                }
                if(exists){
                  break;
                }
              }
              else{
                typeError(not_object);
              }
            }
            else{
              super=classInfo.superClassName;
            } 
          }
          else{
            typeError(undefined_variable);
          }
        }
      }
    }
    else{
      typeError(undefined_class);
    }
  }
  //End of Block2
}

void TypeCheck::visitVariableNode(VariableNode* node) {
  std::map<std::string, VariableInfo>::iterator variable_iter=currentVariableTable->find(node->identifier->name); ; 
  std::map<std::string, VariableInfo>::iterator super_variable_iter; 
  std::map<std::string, ClassInfo>::iterator class_iter;
  std::map<std::string, ClassInfo>::iterator super_class_iter;
  VariableTable* variableTable;
  VariableTable* superVariableTable;
  VariableInfo variableInfo;
  ClassInfo classInfo;
  ClassInfo superClassInfo;
  std::string super;
  bool exists=false;

  if(variable_iter==currentVariableTable->end()){
    class_iter=classTable->find(currentClassName);
    if(class_iter!=classTable->end()){
      classInfo=class_iter->second;
      variableTable=classInfo.members;
      variable_iter=variableTable->find(node->identifier->name);
      if(variable_iter==variableTable->end()){
        super=class_iter->second.superClassName;
        while(!exists){
          if(super==""){
              typeError(undefined_variable);
          }
          super_class_iter=classTable->find(super);
          if(super_class_iter!=classTable->end()){
            superClassInfo=super_class_iter->second;
            superVariableTable=superClassInfo.members;
            super_variable_iter=superVariableTable->find(node->identifier->name);
            if(super_variable_iter==superVariableTable->end()){ 
                super=superClassInfo.superClassName;
            }
            else{ 
              exists=true;
              variableInfo=super_variable_iter->second;
              node->basetype=variableInfo.type.baseType;
              node->objectClassName=variableInfo.type.objectClassName;
            }
          }
          else{
            typeError(undefined_class);
          }
        } 
      }
      else{
        variableInfo=variable_iter->second;
        node->basetype=variableInfo.type.baseType;
        node->objectClassName=variableInfo.type.objectClassName;
      }
    }
    else{
      typeError(undefined_class); 
    }
  }
  else{
    variableInfo=variable_iter->second;
    node->basetype=variableInfo.type.baseType;
    node->objectClassName=variableInfo.type.objectClassName;
  }
}

void TypeCheck::visitIntegerLiteralNode(IntegerLiteralNode* node) {
    node->basetype=bt_integer;
}

void TypeCheck::visitBooleanLiteralNode(BooleanLiteralNode* node) {
    node->basetype=bt_boolean;
}

void TypeCheck::visitNewNode(NewNode* node) {
  
   node->visit_children(this);
   node->basetype=bt_object;
   node->objectClassName=node->identifier->name;
   /*
   if(classTable->count(node->identifier->name)==0){
        typeError(undefined_class);
    }
   
    if(classTable->find(node->identifier->name)->second.methods->count(node->identifier->name)==0){
      //typeError(undefined_method);
      }
   
    
    MethodInfo methodInfo=classTable->find(node->identifier->name)->second.methods->find(node->identifier->name)->second;
    if(node->expression_list->size()!=methodInfo.parameters->size()){
        typeError(argument_number_mismatch);
    }
    std::list<CompoundType>::iterator mParams=methodInfo.parameters->begin();
    for(std::list<ExpressionNode*>::iterator i=node->expression_list->begin(); i!=node->expression_list->end(); i++){
        if((*i)->basetype!=(*mParams).baseType||(*i)->objectClassName!=(*mParams).objectClassName){
            typeError(argument_type_mismatch);
        }
        mParams++;
     }
   */
  
    
}

void TypeCheck::visitIntegerTypeNode(IntegerTypeNode* node) {
    node->basetype=bt_integer;
}

void TypeCheck::visitBooleanTypeNode(BooleanTypeNode* node) {
    node->basetype=bt_boolean;
}

void TypeCheck::visitObjectTypeNode(ObjectTypeNode* node) {
    node->basetype=bt_object;
    node->objectClassName=node->identifier->name;
}

void TypeCheck::visitNoneNode(NoneNode* node) {
    node->basetype=bt_none;
}

void TypeCheck::visitIdentifierNode(IdentifierNode* node) {

}

void TypeCheck::visitIntegerNode(IntegerNode* node) {
    node->basetype=bt_integer;
}


// The following functions are used to print the Symbol Table.
// They do not need to be modified at all.

std::string genIndent(int indent) {
  std::string string = std::string("");
  for (int i = 0; i < indent; i++)
    string += std::string(" ");
  return string;
}

std::string string(CompoundType type) {
  switch (type.baseType) {
    case bt_integer:
      return std::string("Integer");
    case bt_boolean:
      return std::string("Boolean");
    case bt_none:
      return std::string("None");
    case bt_object:
      return std::string("Object(") + type.objectClassName + std::string(")");
    default:
      return std::string("");
  }
}


void print(VariableTable variableTable, int indent) {
  std::cout << genIndent(indent) << "VariableTable {";
  if (variableTable.size() == 0) {
    std::cout << "}";
    return;
  }
  std::cout << std::endl;
  for (VariableTable::iterator it = variableTable.begin(); it != variableTable.end(); it++) {
    std::cout << genIndent(indent + 2) << it->first << " -> {" << string(it->second.type);
    std::cout << ", " << it->second.offset << ", " << it->second.size << "}";
    if (it != --variableTable.end())
      std::cout << ",";
    std::cout << std::endl;
  }
  std::cout << genIndent(indent) << "}";
}

void print(MethodTable methodTable, int indent) {
  std::cout << genIndent(indent) << "MethodTable {";
  if (methodTable.size() == 0) {
    std::cout << "}";
    return;
  }
  std::cout << std::endl;
  for (MethodTable::iterator it = methodTable.begin(); it != methodTable.end(); it++) {
    std::cout << genIndent(indent + 2) << it->first << " -> {" << std::endl;
    std::cout << genIndent(indent + 4) << string(it->second.returnType) << "," << std::endl;
    std::cout << genIndent(indent + 4) << it->second.localsSize << "," << std::endl;
    print(*it->second.variables, indent + 4);
    std::cout <<std::endl;
    std::cout << genIndent(indent + 2) << "}";
    if (it != --methodTable.end())
      std::cout << ",";
    std::cout << std::endl;
  }
  std::cout << genIndent(indent) << "}";
}

void print(ClassTable classTable, int indent) {
  std::cout << genIndent(indent) << "ClassTable {" << std::endl;
  for (ClassTable::iterator it = classTable.begin(); it != classTable.end(); it++) {
    std::cout << genIndent(indent + 2) << it->first << " -> {" << std::endl;
    if (it->second.superClassName != "")
      std::cout << genIndent(indent + 4) << it->second.superClassName << "," << std::endl;
    print(*it->second.members, indent + 4);
    std::cout << "," << std::endl;
    print(*it->second.methods, indent + 4);
    std::cout <<std::endl;
    std::cout << genIndent(indent + 2) << "}";
    if (it != --classTable.end())
      std::cout << ",";
    std::cout << std::endl;
  }
  std::cout << genIndent(indent) << "}" << std::endl;
}

void print(ClassTable classTable) {
  print(classTable, 0);
}
