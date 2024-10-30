#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>

using namespace std;

// Определение входных и выходных символов
enum Symbol {
    SYMBOL_0,
    SYMBOL_1
};

// Класс автомата
class Automaton {
public:
    // Определение состояний
    enum State {
        STATE_A,
        STATE_B,
        STATE_C,
        STATE_D,
        STATE_E
    };

    // Конструктор
    Automaton() : currentState(STATE_A) {}

    // Функция для обработки входного символа
    Symbol processInput(Symbol input) {
        Symbol output = SYMBOL_0;

        switch (currentState) {
            case STATE_A:
                if (input == SYMBOL_0) {
                    currentState = STATE_B;
                    output = SYMBOL_1;
                } else {
                    currentState = STATE_C;
                    output = SYMBOL_0;
                }
                break;
            case STATE_B:
                if (input == SYMBOL_0) {
                    currentState = STATE_D;
                    output = SYMBOL_0;
                } else {
                    currentState = STATE_E;
                    output = SYMBOL_1;
                }
                break;
            case STATE_C:
                if (input == SYMBOL_0) {
                    currentState = STATE_A;
                    output = SYMBOL_1;
                } else {
                    currentState = STATE_B;
                    output = SYMBOL_0;
                }
                break;
            case STATE_D:
                if (input == SYMBOL_0) {
                    currentState = STATE_C;
                    output = SYMBOL_0;
                } else {
                    currentState = STATE_D;
                    output = SYMBOL_1;
                }
                break;
            case STATE_E:
                if (input == SYMBOL_0) {
                    currentState = STATE_E;
                    output = SYMBOL_0;
                } else {
                    currentState = STATE_C;
                    output = SYMBOL_1;
                }
                break;
            default:
                break;
        }
        return output;
    }

    // Функция для запуска автомата на входной последовательности
    vector<Symbol> run(const vector<Symbol>& input) {
        vector<Symbol> output;
        for (Symbol symbol : input) {
            output.push_back(processInput(symbol));
        }
        return output;
    }

private:
    State currentState;
};

// Структура для хранения входных и выходных последовательностей
struct TestSequence {
    vector<Symbol> input;
    vector<Symbol> output;
};

// Оператор << для вывода вектора символов
ostream& operator<<(ostream& os, const vector<Symbol>& symbols) {
    for (Symbol symbol : symbols) {
        if (symbol == SYMBOL_0) {
            os << "0";
        } else {
            os << "1";
        }
    }
    return os;
}

vector<TestSequence> readTestSequences(const string& filename) {
    vector<TestSequence> testSequences;
    ifstream file(filename);

    if (!file.is_open()) {
        cerr << "Error: Unable to open file: " << filename << endl;
        return testSequences; // Return an empty vector if file open fails
    }

    string line;
    // Add this line to ensure there is always a return value:
    if (getline(file, line)) {
        while (getline(file, line)) { // Loop for the rest of the lines
            TestSequence sequence;
            size_t delimiter = line.find(',');
            if (delimiter != string::npos) {
                string inputString = line.substr(0, delimiter);
                string outputString = line.substr(delimiter + 1);

                // Преобразование входных и выходных строк в векторы символов
                for (char c : inputString) {
                    if (c == '0') {
                        sequence.input.push_back(SYMBOL_0);
                    } else if (c == '1') {
                        sequence.input.push_back(SYMBOL_1);
                    }
                }
                for (char c : outputString) {
                    if (c == '0') {
                        sequence.output.push_back(SYMBOL_0);
                    } else if (c == '1') {
                        sequence.output.push_back(SYMBOL_1);
                    }
                }

                testSequences.push_back(sequence);
            }
        }
    }

    file.close();
    return testSequences; // Return the collected test sequences
}

int main() {
    // Чтение тестовых последовательностей из файла
    vector<TestSequence> testSequences = readTestSequences("test_sequences.txt");

    // Проверка автомата на тестовых последовательностях
    for (const TestSequence& sequence : testSequences) {
        Automaton automaton;
        vector<Symbol> actualOutput = automaton.run(sequence.input);

        // Сравнение ожидаемого и фактического результата
        cout << "Input: " << sequence.input << endl;
        cout << "Expected output: " << sequence.output << endl;
        cout << "Actual output: " << actualOutput << endl;
        if (actualOutput == sequence.output) {
            cout << "Test passed." << endl;
        } else {
            cout << "Test failed." << endl;
        }
        cout << endl;
    }

    return 0;
}
