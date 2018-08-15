#include "codegeneration.hpp"

// CodeGenerator Visitor Functions: These are the functions
// you will complete to generate the x86 assembly code. Not
// all functions must have code, many may be left empty.

void CodeGenerator::visitProgramNode(ProgramNode* node) {
  std::cout << " .data" << std::endl;
  std::cout << " printstr: .asciz \"%d\\n\"" << std::endl;
  std::cout << " .text" << std::endl;
  std::cout << " .globl Main_main" << std::endl;

  node->visit_children(this);
}

void CodeGenerator::visitClassNode(ClassNode* node) {
  currentClassName=node->identifier_1->name;
  currentClassInfo=(*classTable)[currentClassName];

  node->visit_children(this);
}

void CodeGenerator::visitMethodNode(MethodNode* node) {
  
  currentMethodName=node->identifier->name;
  currentMethodInfo=currentClassInfo.methods->find(currentMethodName)->second;

  std::cout << " "<<currentClassName <<"_"<< currentMethodName << ":" << std::endl;
  std::cout << " push %ebp" << std::endl;
  std::cout << " mov %esp, %ebp" << std::endl;

  if(currentMethodInfo.localsSize>0){
    std::cout << "  sub $"<< currentMethodInfo.localsSize <<", %esp" << std::endl;
  }
  
  node ->visit_children(this);

  if(currentMethodInfo.localsSize >0){
    std::cout << "  add $"<< currentMethodInfo.localsSize <<", %esp" << std::endl;
  }
  std::cout << "  leave" << std::endl;
  std::cout << "  ret" << std::endl;
  
}

void CodeGenerator::visitMethodBodyNode(MethodBodyNode* node) {
   node->visit_children(this);

}

void CodeGenerator::visitParameterNode(ParameterNode* node) {
  node->visit_children(this);
}

void CodeGenerator::visitDeclarationNode(DeclarationNode* node) {
  node->visit_children(this);
}

void CodeGenerator::visitReturnStatementNode(ReturnStatementNode* node) {
  node->visit_children(this);
  std::cout << "  pop %eax" << std::endl;
}

void CodeGenerator::visitAssignmentNode(AssignmentNode* node) {
    node->visit_children(this);
    std::cout << "  pop %eax"<< std::endl;
    if (node->identifier_2 == NULL) {
        if (currentMethodInfo.variables->count(node->identifier_1->name) > 0) {
            std::cout << "  mov %eax, " << currentMethodInfo.variables->find(node->identifier_1->name)->second.offset<<"(%ebp)"<< std::endl;
        } else {
            std::cout << "  mov 8(%ebp), %edx" << std::endl;
            std::cout << "  mov %eax, " << currentClassInfo.members->find(node->identifier_1->name)->second.offset<<"(%edx)"<< std::endl;

        }
    } else {
        VariableInfo objectInfo;
        if (currentMethodInfo.variables->count(node->identifier_1->name) >0) {
            objectInfo = currentMethodInfo.variables->find(node->identifier_1->name)->second;
        } else {
            objectInfo = currentClassInfo.members->find(node->identifier_1->name)->second;
        }
        std::cout << "  mov " << objectInfo.offset <<"(%ebp), %edx" << std::endl;
        int memberoffset = classTable->find(objectInfo.type.objectClassName)->second.members->find(node->identifier_2->name)->second.offset;
        std::cout << "  mov %eax, " << memberoffset <<"(%edx)" << std::endl;
        

    }
    // WRITEME: Replace with code if necessary   
}

void CodeGenerator::visitCallNode(CallNode* node) {
  node->visit_children(this);
}

void CodeGenerator::visitIfElseNode(IfElseNode* node) {
  
  node->expression->accept(this);
  int label=nextLabel();
  if(node->statement_list_2 == 0){
    std::cout << "  pop %edx" << std::endl;
    std::cout << "  cmp $0, %edx" << std::endl;
    std::cout << "  je skip_if_" << label << std::endl;
    for(std::list<StatementNode*>::iterator it = node->statement_list_1->begin(); it != node->statement_list_1->end(); ++it){
      (*it)->accept(this);
    }
    std::cout << "  skip_if_" << label << ":" << std::endl;
  }

  else{
    std::cout << "  pop %edx" << std::endl;
    std::cout << "  cmp $0, %edx" << std::endl;
    std::cout << "  je skip_if_" << label << std::endl;
    for(std::list<StatementNode*>::iterator it = node->statement_list_1->begin(); it != node->statement_list_1->end(); ++it){
      (*it)->accept(this);
    }
    std::cout << "  jmp skip_else_" << label << std::endl;
    std::cout << "  skip_if_" << label << ":" << std::endl;
    for(std::list<StatementNode*>::iterator it = node->statement_list_2->begin(); it != node->statement_list_2->end(); ++it){
      (*it)->accept(this);
    }
    std::cout << "  skip_else_" << label << ":" << std::endl;   
  }

}

void CodeGenerator::visitWhileNode(WhileNode* node) {
  
    int label=nextLabel();
    std::cout << "  while_start_"<< label << ":" << std::endl;
    node->expression->accept(this);
    std::cout << "  pop %edx" << std::endl;
    std::cout << "  cmp $0, %edx" << std::endl;
    std::cout << "  je end_while" << label << std::endl;
    if (node->statement_list->size() > 0){
      for(std::list<StatementNode*>::iterator iter = node->statement_list->begin(); iter!=node->statement_list->end(); iter++){
	(*iter)->accept(this);
      }
    }
    std::cout << "  jmp while_start_" << label << std::endl;
    std::cout << "  end_while" << label << ":" << std::endl;
}

void CodeGenerator::visitPrintNode(PrintNode* node) {
  node->visit_children(this);
  std::cout << "  push $printstr" << std::endl;
  std::cout << "  call printf" << std::endl;
  std::cout << "  add $4, %esp" << std::endl;
}

void CodeGenerator::visitDoWhileNode(DoWhileNode* node) {
  int label=nextLabel();
  std::cout << " do_while_start_"<< label << ":" << std::endl;
  if (node->statement_list->size() > 0){
    for(std::list<StatementNode*>::iterator iter = node->statement_list->begin(); iter!=node->statement_list->end(); iter++){
      (*iter)->accept(this);
    }
  }
  node->expression->accept(this);
  std::cout << " pop %edx" << std::endl;
  std::cout << " cmp $0, %edx" << std::endl;
  std::cout << " je end_dowhile" << label << std::endl;
  std::cout << " jmp do_while_start_" << label << std::endl;
  std::cout << " end_dowhile" << label << ":" << std::endl;
}

void CodeGenerator::visitPlusNode(PlusNode* node) {
  node->visit_children(this);
  std::cout << "  # Plus" << std::endl;
  std::cout << "  pop %edx" << std::endl;
  std::cout << "  pop %eax" << std::endl;
  std::cout << "  add %edx, %eax" << std::endl;
  std::cout << "  push %eax" << std::endl;
}

void CodeGenerator::visitMinusNode(MinusNode* node) {
  node->visit_children(this);
  std::cout << "  # Minus" << std::endl;
  std::cout << "  pop %edx" << std::endl;
  std::cout << "  pop %eax" << std::endl;
  std::cout << "  sub %edx, %eax" << std::endl;
  std::cout << "  push %eax" << std::endl;
}

void CodeGenerator::visitTimesNode(TimesNode* node) {
  node->visit_children(this);
  std::cout << "  # Times" << std::endl;
  std::cout << "  pop %edx" << std::endl;
  std::cout << "  pop %eax" << std::endl;
  std::cout << "  imul %edx, %eax" << std::endl;
  std::cout << "  push %eax" << std::endl;
}

void CodeGenerator::visitDivideNode(DivideNode* node) {
  node->visit_children(this);
  std::cout << "  # Divide" << std::endl;
  std::cout << "  pop %ebx" << std::endl;
  std::cout << "  pop %eax" << std::endl;
  std::cout << "  cdq" << std::endl;
  std::cout << "  idiv %ebx" << std::endl;
  std::cout << "  push %eax" << std::endl;
}

void CodeGenerator::visitGreaterNode(GreaterNode* node) {
  node->visit_children(this);
    int label=nextLabel();
  std::cout << "  pop %edx" << std::endl;
  std::cout << "  pop %eax" << std::endl;
  std::cout << "  cmp %edx, %eax" << std::endl;
  std::cout << "  jg greater_" << label << std::endl;
  std::cout << "  push $0" << std::endl;
  std::cout << "  jmp notgreater_" << label << std::endl;
  std::cout << "  greater_" << label<<":" << std::endl;
  std::cout << "  push $1" << std::endl;
  std::cout << "  notgreater_" << label <<":" << std::endl;
}

void CodeGenerator::visitGreaterEqualNode(GreaterEqualNode* node) {
  node->visit_children(this);
  int label=nextLabel();
  std::cout << "  pop %ebx" << std::endl;
  std::cout << "  pop %eax" << std::endl;
  std::cout << "  cmp %ebx, %eax" << std::endl;
  std::cout << "  jge greatequal_" << label << std::endl;
  std::cout << "  push $0" << std::endl;
  std::cout << "  jmp notgreatequal_" << label << std::endl;
  std::cout << "  greatequal_" << label<<":" << std::endl;
  std::cout << "  push $1" << std::endl;
  std::cout << "  notgreatequal_" << label <<":" << std::endl;
}

void CodeGenerator::visitEqualNode(EqualNode* node) {
  node->visit_children(this);
  int label=nextLabel();
  std::cout << "  pop %edx" << std::endl;
  std::cout << "  pop %eax" << std::endl;
  std::cout << "  cmp %edx, %eax" << std::endl;
  std::cout << "  je equal_" << label << std::endl;
  std::cout << "  push $0" << std::endl;
  std::cout << "  jmp notequal_" << label << std::endl;
  std::cout << "  equal_" << label<<":" << std::endl;
  std::cout << "  push $1" << std::endl;
  std::cout << "  notequal_" << label <<":" << std::endl;
}

void CodeGenerator::visitAndNode(AndNode* node) {
  node->visit_children(this);
  std::cout << "  pop %edx" << std::endl;
  std::cout << "  pop %eax" << std::endl;
  std::cout << "  and %edx, %eax" << std::endl;
  std::cout << "  push %eax" << std::endl;
}

void CodeGenerator::visitOrNode(OrNode* node) {
  node->visit_children(this);
  std::cout << "  pop %edx" << std::endl;
  std::cout << "  pop %eax" << std::endl;
  std::cout << "  or %edx, %eax" << std::endl;
  std::cout << "  push %eax" << std::endl;
}

void CodeGenerator::visitNotNode(NotNode* node) {
  node->visit_children(this);
  std::cout << "  pop %eax" << std::endl;
  std::cout << "  xor $1, %eax" << std::endl;
  std::cout << "  push %eax" << std::endl;
}

void CodeGenerator::visitNegationNode(NegationNode* node) {
  node->visit_children(this);
  std::cout << "  pop %eax" << std::endl;
  std::cout << "  neg %eax" << std::endl;
  std::cout << "  push %eax" << std::endl;
}

void CodeGenerator::visitMethodCallNode(MethodCallNode* node) {
  
  std::string className;
  std::string variableClass;
  int offset;
  ClassInfo classInfo;
  if(node->identifier_1 && node->identifier_2){
    //method called like: 'identifier1.identifier2()'
    if(currentMethodInfo.variables->count(node->identifier_1->name)>0){
      //identifer1 is local
      variableClass=currentMethodInfo.variables->find(node->identifier_1->name)->second.type.objectClassName;
      offset=currentMethodInfo.variables->find(node->identifier_1->name)->second.offset;
    }
    else{
      //identifier1 is a member variable
      variableClass=currentClassInfo.members->find(node->identifier_1->name)->second.type.objectClassName;
      offset=currentClassInfo.members->find(node->identifier_1->name)->second.offset;
    }
    classInfo=classTable->find(variableClass)->second;
    if(classInfo.methods->count(node->identifier_2->name)>0){
      className=variableClass;
    }
    else{
      while(classInfo.methods->count(node->identifier_2->name)<=0){
	variableClass=classInfo.superClassName;
	classInfo=classTable->find(classInfo.superClassName)->second;
      }
      className=variableClass;
    }
    for(std::list<ExpressionNode*>::reverse_iterator it = node->expression_list->rbegin(); it != node->expression_list->rend(); ++it){
      (*it)->accept(this);
    }
    std::cout << "  push " << offset << "(%ebp)" << std::endl;
    std::cout << "  call " << className << "_" << node->identifier_2->name << std::endl;
    std::cout << "  add $4, %esp" << std::endl;
    std::cout << "  add $" << node->expression_list->size()*4 << ", %esp" << std::endl;
    std::cout << "  push %eax" << std::endl;
  }
  else{
    classInfo=currentClassInfo;
    if(currentClassInfo.methods->count(node->identifier_1->name)>0){
      className=currentClassName;
    }
    else{
      while(classInfo.methods->count(node->identifier_1->name)<=0){
	className=classInfo.superClassName;
	classInfo=classTable->find(classInfo.superClassName)->second;
      }
    }
    for(std::list<ExpressionNode*>::reverse_iterator it = node->expression_list->rbegin(); it != node->expression_list->rend(); ++it){
      (*it)->accept(this);
    }
    std::cout << "  push 8(%ebp)" << std::endl;
    std::cout << "  call " << className << "_" << node->identifier_1->name << std::endl;
    std::cout << "  add $4, %esp" << std::endl;
    std::cout << "  add $" << node->expression_list->size()*4 << ", %esp" << std::endl;
    std::cout << "  push %eax" << std::endl;
  }
 
}


void CodeGenerator::visitMemberAccessNode(MemberAccessNode* node) {
   int offset;
   int variableOffset;
   std::string variableClass;
   node->visit_children(this);
   if(currentMethodInfo.variables->count(node->identifier_1->name)>0){
     //identifier_1 of 'identifier_1.identifier_2' is a local variable
     variableClass=currentMethodInfo.variables->find(node->identifier_1->name)->second.type.objectClassName;
     variableOffset=currentMethodInfo.variables->find(node->identifier_1->name)->second.offset;

     offset=classTable->find(variableClass)->second.members->find(node->identifier_2->name)->second.offset;
     std::cout << "  mov " << variableOffset << "(%ebp), " << "%edx" << std::endl;
     std::cout << "  push " << offset << "(%edx)" << std::endl;
   }
   else{
     //identifier_1 of 'identifier_1.identifier_2' is a member variable
     variableClass=currentClassInfo.members->find(node->identifier_1->name)->second.type.objectClassName;
     variableOffset=currentClassInfo.members->find(node->identifier_1->name)->second.offset;
     
     offset=classTable->find(variableClass)->second.members->find(node->identifier_2->name)->second.offset;
     std::cout << "  mov 8(%ebp), %edx" << std::endl;
     std::cout << "  mov " << variableOffset << "(%edx), " << "%ebx" << std::endl;
     std::cout << "  push " << offset << "(%ebx)" << std::endl;
     }
}

void CodeGenerator::visitVariableNode(VariableNode* node) {
  
  int offset; 
  if(currentMethodInfo.variables->count(node->identifier->name)>0){
    offset=currentMethodInfo.variables->find(node->identifier->name)->second.offset;
    std::cout << "  push " << offset << "(%ebp)" << std::endl;
  }
  else{
    offset=currentClassInfo.members->find(node->identifier->name)->second.offset;
    std::cout << "  mov 8(%ebp), %edx" << std::endl;
    std::cout << "  push " << offset << "(%edx)" << std::endl; 
  }

}

void CodeGenerator::visitIntegerLiteralNode(IntegerLiteralNode* node) {
    std::cout << "  push $"<< node->integer->value<< std::endl;
}

void CodeGenerator::visitBooleanLiteralNode(BooleanLiteralNode* node) {
    std::cout << "  push $"<< node->integer->value<< std::endl;
}

void CodeGenerator::visitNewNode(NewNode* node) {

   ClassInfo classInfo = classTable->find(node->identifier->name)->second;
    if(node->expression_list->size()<=0){
        std::cout << "  push $" << classInfo.membersSize << std::endl;
        std::cout << "  call malloc" << std::endl;
        std::cout << "  add $4, %esp" << std::endl;
        std::cout << "  push %eax" << std::endl;
        std::cout << "  mov %eax, %ecx" << std::endl;
        
        if(classInfo.methods->count(node->identifier->name)>0){
            std::cout << "  push %ecx" << std::endl;
            std::cout << "  call " << node->identifier->name << "_" << node->identifier->name << std::endl;
            std::cout << "  add $4, %esp" << std::endl;
        } 
    }
    else{
        std::cout << "  push $" << classInfo.membersSize << std::endl;
        std::cout << "  call malloc" << std::endl;
        std::cout << "  add $4, %esp" << std::endl;
        std::cout << "  push %eax" << std::endl;
        std::cout << "  mov %eax, %ecx" << std::endl;
        for(std::list<ExpressionNode*>::reverse_iterator i=node->expression_list->rbegin(); i!=node->expression_list->rend(); i++){
            (*i)->accept(this);
        }
        std::cout << "  push %ecx" <<  std::endl;
        std::cout << "  call " << node->identifier->name << "_" << node->identifier->name << std::endl;
        std::cout << "  add $4, %esp" << std::endl;
        std::cout << "  add $" << node->expression_list->size()*4 << ", %esp" << std::endl;
    }
  
}

void CodeGenerator::visitIntegerTypeNode(IntegerTypeNode* node) {
    // WRITEME: Replace with code if necessary
}

void CodeGenerator::visitBooleanTypeNode(BooleanTypeNode* node) {
    // WRITEME: Replace with code if necessary
}

void CodeGenerator::visitObjectTypeNode(ObjectTypeNode* node) {
    // WRITEME: Replace with code if necessary
}

void CodeGenerator::visitNoneNode(NoneNode* node) {
    // WRITEME: Replace with code if necessary
}

void CodeGenerator::visitIdentifierNode(IdentifierNode* node) {
    // WRITEME: Replace with code if necessary
}

void CodeGenerator::visitIntegerNode(IntegerNode* node) {
    // WRITEME: Replace with code if necessary
}
