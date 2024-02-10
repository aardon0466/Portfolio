#include <iostream>
#include <string>

using namespace std;

//[A * {B + (C + D)}]
//[{()()}]
//[A * {B + (C + D})]
//{(])()}

class Stack {
public:
	int top;
	char exp[100];
	Stack() { top = -1; }
	// functions prototypes
	bool push(char item);
	char pop();
};

//Stack functions
bool Stack::push(char item) {
	if (top >= 99) {
		cout << "Stack Overflow" << endl;
		return 0;
	}
	else {
		top++;
		exp[top] = item;
		//cout << item << " is successfully pushed into stack\n";
		return true;
	}
}
char Stack::pop() {
	if (top < 0) {
		cout << "Stack Underflow";
		return 0;
	}
	else {

		int n = exp[top];
		top--;
		return n;
	}
}

//Balance functions
int isMatchingPair(char character1, char character2) {
	if (character1 == '(' && character2 == ')') {
		return 1;
	}
	else if (character1 == '[' && character2 == ']') {
		return 1;
	}
	else if (character1 == '{' && character2 == '}') {
		return 1;
	}
	else {
		return 0;
	}
}
int areParenthesisBalanced(char exp[]) {
	int i = 0;
	
	Stack stack;
	
	while (i < 99)
	{
		if (exp[i] == '{' || exp[i] == '(' || exp[i] == '[')
			stack.push(exp[i]);
		if (exp[i] == '}' || exp[i] == ')'
			|| exp[i] == ']') {
			if (&stack == NULL)
				return 0;
			else if (!isMatchingPair(stack.pop(), exp[i]))
				return 0;
		}
		i++;
	}
	if (&stack == NULL)
		return 0;
	else
		return 1;
}

int main(void) {
	Stack newStack;
	string s;
	cout << "enter the expression : \n";
	getline(cin, s);

	for (int i = 0; i < s.size(); i++) {
		newStack.exp[i] = s.at(i);
	}

	if (areParenthesisBalanced(newStack.exp)) {
		cout << "Balanced" << endl;
	}
	else
		cout << "Not Balanced" << endl;
		return 0;
}
