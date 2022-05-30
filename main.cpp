#include <bits/stdc++.h>
#include <atcoder/dsu>
using namespace std;

struct Board {
    int n;
    vector<vector<int>> tiles;

    Board(vector<vector<int>> _tiles) {
        n = _tiles.size();
        tiles = _tiles;
    }
};

Board read_input() {
    int n, t;
    cin >> n >> t;

    auto to_int = [](char c) -> int {
        if ('0' <= c and c <= '9') return c - '0';
        return c - 'a' + 10;
    };

    vector<vector<int>> tiles(n, vector<int>(n));
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++) {
            char c;
            cin >> c;
            tiles[i][j] = to_int(c);
        }

    return Board(tiles);
}

int main() {
    Board board = read_input();
    cerr << board.n << endl;
}