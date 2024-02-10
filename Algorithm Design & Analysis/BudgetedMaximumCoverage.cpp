#include <iostream>
#include <string>
#include <vector>
#include <cstdlib>
#include <time.h>
#include <math.h>
#include <algorithm>
#include <functional>

using namespace std;

static int total = 20;
int cID = 100;

class Consumer {
public:
    int ID;
    int x;
    int y;
    int radius = 5;
    int cost = 0;
    double weight = 0;
    
    // weight/cost
    double weightCost = 0;
    
    //Vector of the other consumers within radius
    vector<Consumer> W;

    //Constructor
    Consumer(int newX, int newY, int newC) {
        x = newX;
        y = newY;
        cost = newC;
        ID = cID;

        cID++;
    }

    //Define the weight, weight vector, and weightCost
    void createW(vector<Consumer> input) {
        W.clear();
        weight = 0;
        for (int i = 0; i < input.size(); i++) {
            double dist = sqrt(pow(input[i].x - x, 2) + pow(input[i].y - y, 2));
            if (dist <= radius) {
                W.push_back(input[i]);
                weight += 1;
            }
        }
        weightCost = weight / cost;
    }

    //Print the consumers information
    void printInfo() {
        cout << "U" << ID << " Coordinates: (" << x << "," << y << ") Cost: " << cost << endl;
    }

    //Print the weight vector
    void printW() {
        cout << "U" << ID << " contains: ";
        for (int i = 0; W.size() > i; i++) {
            cout << W[i].ID << " ";
        }
        cout << endl;
    }

    //Overload operators for sorting
    bool operator < (const Consumer& input) const
    {
        return (weightCost < input.weightCost);
    }
    bool operator > (const Consumer& input) const
    {
        return (weightCost > input.weightCost);
    }

};

//The Algorithm
void Algorithm(vector<Consumer> U) {
    //Create a vector for the solution set
    vector<Consumer> G;
    
    //Assign the budget
    double budget = 15;
    
    //Set the final cost to zero
    double tCost = 0;
    
    //Algorithm
    do {
        /*  Select consumer that maximizes W/C    */
        sort(U.begin(), U.end(), greater<Consumer>());

        //If the selected consumer is within budget, add them to solution set (G)
        if (tCost + U[0].cost <= budget) {
            G.push_back(U[0]);
            tCost += U[0].cost;
        }

        //Remove the selected consumer and update the remaining consumers
        U.erase(U.begin());
        for (int i = 0; i < U.size(); i++) {
            U[i].createW(U);
        }
    } while (U.size() > 0);

    //Print the solution
    cout << "The Solution Set is: " << endl;
    for (int i = 0; i < G.size(); i++) {
        G[i].printInfo();
    }
    cout << "The total cost is: " << tCost << endl;
}

int main(void) {
    srand(time(0));

    vector<Consumer> U;

    /*      Create every Consumer and place them into a vector      */

    /*      Uniform Variation  
    int xStart = 0;
    int yStart = 0;
    for (int i = 0; i < total; i++) {
        int c = (rand() % 7) + 1;
        U.push_back(Consumer(xStart, yStart, c));

        xStart += 5;

        if (xStart > 15) {
            xStart = 0;
            yStart += 5;
        }
    }
    // */


  /*      Random Variation
  for (int i = 0; i < total; i++) {
      int x = rand() % 26;
      int y = rand() % 26;
      int c = (rand() % 7) + 1;

      U.push_back(Consumer(x, y, c));
  }
    */

    /*      Neighborhood Variation      */
    // High Income
    for (int i = 0; i < total/4; i++) {
        int x = rand() % 21;
        int y = rand() % 21;
        int c = (rand() % 3) + 7;

        U.push_back(Consumer(x, y, c));
    }
    // High-Mid Income
    for (int i = 0; i < total/4; i++) {
        int x = (rand() % 20) + 31;
        int y = rand() % 21;
        int c = (rand() % 2) + 5;

        U.push_back(Consumer(x, y, c));
    }
    // Low-Mid Income
    for (int i = 0; i < total/4; i++) {
        int x = rand() % 21;
        int y = (rand() % 20) + 31;
        int c = (rand() % 3) + 2;

        U.push_back(Consumer(x, y, c));
    }// Low Income
    for (int i = 0; i < total/4; i++) {
        int x = (rand() % 20) + 31;
        int y = (rand() % 20) + 31;
        double c = (rand() % 2) + 1;

        U.push_back(Consumer(x, y, c));
    }

      // */

      //Find the weight of each Consumer
    for (int i = 0; i < total; i++) {
        U[i].createW(U);
        //U[i].printInfo();
    }
    cout << endl;

    //Run the Algorithm
    Algorithm(U);

    return 0;
}