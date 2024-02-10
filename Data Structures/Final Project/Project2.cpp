#include <iostream>
#include <string.h>
#include <stdlib.h>
using std::string;

FILE* outfile;

//For the items of each tree Name
class itemNode
{
public:
	char name[50];
	int count;
	itemNode* left, * right;
	itemNode()
	{
		name[0] = '\0';
		count = 0;
		left = NULL;
		right = NULL;
	}
	itemNode(char itemName[], int population)
	{
		strcpy(name, itemName);
		count = population;
		left = NULL;
		right = NULL;
	}
};

//For Tree Names
class treeNameNode
{
public:
	char treeName[50];
	treeNameNode* left, * right;
	itemNode* theTree;
	treeNameNode()
	{
		treeName[0] = '\0';
		theTree = NULL;
		left = NULL;
		right = NULL;
	}
	treeNameNode(char name[])
	{
		strcpy(treeName, name);
		theTree = NULL;
		left = NULL;
		right = NULL;
	}
};

/** Basic Functions **/
void inOrder(treeNameNode* root) {
	if (root == NULL) {
		return;
	}
	inOrder(root->left);
	std::cout << root->treeName << " ";
	fprintf(outfile, "%s ", root->treeName);
	inOrder(root->right);
}
void itemInOrder(itemNode* root) {
	if (root == NULL) {
		return;
	}
	itemInOrder(root->left);
	std::cout << root->name << " ";
	fprintf(outfile, "%s ", root->name);
	itemInOrder(root->right);
}
//bool isBalanced();
treeNameNode* nameTreeInsert(treeNameNode* root, treeNameNode* temp) {
	if (root == NULL) {
		return temp;
	}
	else {
		if (strcmp(temp->treeName, root->treeName) > 0) {
			root->right = nameTreeInsert(root->right, temp);
		}
		else {
			root->left = nameTreeInsert(root->left, temp);
		}
	}
	return root;
}
itemNode* itemTreeInsert(itemNode* root, itemNode* temp) {
	if (root == NULL) {
		return temp;
	}
	else {
		if (strcmp(temp->name, root->name) > 0) {
			root->right = itemTreeInsert(root->right, temp);
		}
		else {
			root->left = itemTreeInsert(root->left, temp);
		}
	}
	return root;
}

/** Project Functions **/
int countPrev(itemNode* root, char name[]) {
	int prev = 0;
	if (root == NULL) {
		return 0;
	}
	else if (strcmp(root->name, name) == 0) {
		return prev - 3;
	}
	else {
		prev += countPrev(root->left, name);
		prev += countPrev(root->right, name);
		return prev + 1;
	}
}
int totalCount(itemNode* root) {
	int count = 0;
	if (root == NULL) {
		return 0;
	}
	else {
		count += totalCount(root->left);
		count += totalCount(root->right);
		return count + 1;
	}
}
int treePopCount(itemNode* root, int count) {
	if (root == NULL) {
		return 0;
	}
	else {
		count += treePopCount(root->left, count);
		count = root->count;
		count += treePopCount(root->right, count);
		return count;
	}
}
treeNameNode* findNameTree(treeNameNode* root, treeNameNode* found, string name) {
	if (root != NULL) {
		if (root->treeName == name) {
			return root;
		}
		else if (root->treeName > name) {
			return findNameTree(root->left, found, name);
		}
		else if (root->treeName < name) {
			return findNameTree(root->right, found, name);
		}
	}

	return found;
}
itemNode* findItemNode(itemNode* root, itemNode* found, string name) {
	if (root != NULL) {
		if (root->name == name) {
			return root;
		}
		else if (root->name > name) {
			return findItemNode(root->left, found, name);
		}
		else if (root->name < name) {
			return findItemNode(root->right, found, name);
		}
	}

	return found;
}
treeNameNode* buildNameTree(FILE* file, int count) {
	treeNameNode* topTree = NULL;
	char treeName[50];

	for (int i = 0; i < count; i++) {
		fscanf(file, "%s", treeName);
		treeNameNode* temp = new treeNameNode(treeName);
		topTree = nameTreeInsert(topTree, temp);
	}
	return topTree;
}
treeNameNode* buildOtherTrees(FILE* infile, treeNameNode* topTree,int nameCount, int itemCount) {
	char treeName[50], itemName[50];
	treeNameNode* found = NULL;
	int pop;
	for (int i = 0; i < itemCount; i++) {
		fscanf(infile, "%s %s %d", &treeName, &itemName, &pop);
		itemNode* temp = new itemNode(itemName, pop);
		found = topTree;

		found = findNameTree(topTree, found, treeName);
		if (found == NULL) {
			printf("%s does not exist\n", treeName);
			fprintf(outfile, "%s does not exist\n", treeName);
		}
		found->theTree = itemTreeInsert(found->theTree, temp);
	}
	return topTree;
}
void traverseInTraverse(treeNameNode* root) {
	if (root == NULL) {
		return;
	}
	traverseInTraverse(root->left);
	std::cout << "***" << root->treeName << "***\n" << " ";
	fprintf(outfile, "***%s***\n", root->treeName);
	itemInOrder(root->theTree);
	std::cout << std::endl;
	fprintf(outfile, "\n");
	traverseInTraverse(root->right);
}

/** Query Functions **/
int search(treeNameNode* root, char treeName[], char itemName[]) {
	treeNameNode* found = NULL;
	itemNode* itemFound = NULL;
	int pop;
	found = findNameTree(root, found, treeName);
	if (found == NULL) {
		std::cout << treeName << " does not exist" << std::endl;
		fprintf(outfile, "%s does not exist\n", treeName);
		return 0;
	}
	else {
		itemFound = findItemNode(found->theTree, itemFound, itemName);
		if (itemFound == NULL) {
			std::cout << itemName << " not found in " << treeName << std::endl;
			fprintf(outfile, "%s not found in %s\n", itemName, treeName);
			return 0;
		}
		else {
			pop = itemFound->count;
		}
		return pop;
	}
	return 0;
}
int itemBefore(treeNameNode* root, char treeName[], char itemName[], int prev) {
	treeNameNode* found = NULL;
	found = findNameTree(root, found, treeName);
	return countPrev(found->theTree, itemName);
}
bool heightBalance(treeNameNode* root, char treeName[]) {
	int Left, Right, Difference;
	treeNameNode* found = NULL;
	found = findNameTree(root, found, treeName);
	Left = totalCount(found->theTree->left);
	Right = totalCount(found->theTree->right);
	Difference = totalCount(found->theTree->left) - totalCount(found->theTree->right);
	Difference = abs(Difference);
	std::cout << treeName << ": left height " << Left << ", right height " << Right << ", difference " << Difference << ", ";
	fprintf(outfile, "%s: left height %d, right height %d, difference %d, ", treeName, Left, Right, Difference);
	if (Difference > 1) {
		return false;
	}
	else {
		return true;
	}
}
int Count(treeNameNode* root, char treeName[]) {
	int count = 0;
	treeNameNode* found = NULL;
	found = findNameTree(root, found, treeName);
	count = treePopCount(found->theTree, count);

	return count;
}
void performQueries(FILE* infile, treeNameNode* root, int count) {
	char Search[50] = "search", ItemBefore[50] = "item_before", HeightBalance[50] = "height_balance", CountArr[50] = "count";
	char queryType[50];

	for (int i = 0; i < count; i++) {
		fscanf(infile, "%s", queryType);
		if (strcmp(queryType, Search) == 0) {
			char treeName[50], itemName[50];
			int pop;
			fscanf(infile, "%s %s", treeName, itemName);
			pop = search(root, treeName, itemName);
			if (pop != 0) {
				std::cout << pop << " " << itemName << " found in " << treeName << std::endl;
				fprintf(outfile, "%d %s found in %s\n", pop, itemName, treeName);
			}
		}
		else if (strcmp(queryType, ItemBefore) == 0) {
			char treeName[50], itemName[50];
			int prevItems = 0;
			fscanf(infile, "%s %s", treeName, itemName);
			prevItems = itemBefore(root, treeName, itemName, prevItems);
			std::cout << "Item before " << itemName << ": " << prevItems << std::endl;
			fprintf(outfile, "Item before %s: %d\n", itemName, prevItems);
		}
		else if (strcmp(queryType, HeightBalance) == 0) {
			char treeName[50];
			fscanf(infile, "%s", treeName);
			if (heightBalance(root, treeName) == true) {
				std::cout << "balanced" << std::endl;
				fprintf(outfile, "balanced\n");
			}
			else {
				std::cout << "not balanced" << std::endl;
				fprintf(outfile, "not balanced\n");
			}
		}
		else if (strcmp(queryType, CountArr) == 0) {
			char treeName[50];
			fscanf(infile, "%s", treeName);
			std::cout << treeName << " count " << Count(root, treeName) << std::endl;
			fprintf(outfile, "%s count %d\n", treeName, Count(root, treeName));
		}

	}
}

int main(void) {
	FILE* infile = fopen("in.txt", "r");
	outfile = fopen("out.txt", "w");
	treeNameNode* topTree = NULL;

	int tnCount, itemCount, queryCount;
	fscanf(infile, "%d %d %d", &tnCount, &itemCount, &queryCount);

	topTree = buildNameTree(infile, tnCount);
	topTree = buildOtherTrees(infile, topTree, tnCount, itemCount);

	inOrder(topTree);
	printf("\n");
	fprintf(outfile, "\n");
	traverseInTraverse(topTree);

	printf("\n");

	performQueries(infile, topTree, queryCount);
	return 0;
}