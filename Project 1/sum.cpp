#include "sum.hpp"

void SumVisitor::visitNode(Node* node) {
  sum+=node->value;
  node->visit_children(this);
  // Hint: for this function, you will need to to use the sum
	// member of the object.
	
	// WRITEME
}
