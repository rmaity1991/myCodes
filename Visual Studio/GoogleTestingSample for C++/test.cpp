#include "pch.h"
using namespace std;

class Calculator {
public:
	int var1;
	int var2;
	float var3;
	float var4;
	double var5;
	double var6;

	Calculator() {}

	int add(int x, int y) { return x + y; }
	float add(float x, float y) { return x + y; }
	double add(double x, double y) { return x + y; }

	int sub(int x, int y) { return x - y; }
	float sub(float x, float y) { return x - y; }
	double sub(double x, double y) { return x - y; }

	int mul(int x, int y) { return x * y; }
	float mul(float x, float y) { return x * y; }
	double mul(double x, double y) { return x * y; }

	int division(int x, int y) { return x / y; }
	float division(float x, float y) { return x / y; }
	double division(double x, double y) { return x / y; }


};

class CalculatorTest :public ::testing::Test {

public:

	Calculator* x;

	void setup() {
		
	}

	void TearDown() {
		delete x;
	}
};

TEST(TestSum1, TestInt) {

	Calculator x;
	EXPECT_EQ(5, x.add(3, 2));

}

TEST_F(CalculatorTest, FixtureTest1) {

	EXPECT_EQ(5, x->add(4, 5));
}


int main(int argc, char** argv) {

	::testing::InitGoogleTest(&argc, argv);
	return RUN_ALL_TESTS();

}


