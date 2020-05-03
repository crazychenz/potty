#include <vector>
#include <functional> // function/lambda
#include <algorithm> // for_each

template <typename T = int>
class TopologicalSorter
{
    using size_type = typename std::vector<std::vector<T>>::size_type;

    std::vector<std::vector<T>> &adj; // adjacency list of graph
    std::vector<bool> visited;
    std::vector<T> ans;

    void dfs(size_type v) {
        visited[v] = true;
        for (size_type u : adj[v]) {
            if (!visited[u])
                dfs(u);
        }
        ans.push_back(v);
    }

    void topological_sort() {
        visited.assign(adj.size(), false);
        ans.clear();
        for (size_type i = 0; i < adj.size(); ++i) {
            if (!visited[i])
                dfs(i);
        }
    }

public:

    TopologicalSorter(std::vector<std::vector<T>> &adj) :
        adj(adj),
        visited ( adj.size() ), 
        ans ( adj.size() )
    {
        topological_sort();
    }

    std::vector<T>& getSortedVector() { return ans; }

    void for_each(std::function<void(T)> const& lambda) {
        std::for_each(ans.cbegin(), ans.cend(), lambda);
    }
};

template <typename T = int> 
TopologicalSorter<T> topo_sort(std::vector<std::vector<T>> &adj)
{
    return TopologicalSorter<T>(adj);
}

#ifdef PLAY_EXAMPLE
#include <iostream>
int main()
{
    std::vector<std::vector<size_t>> adj = {
        /* 0 depends on */ {5, 4},
        /* 1 depends on */ {4, 3},
        /* 2 depends on */ {5},
        /* 3 depends on */ {2},
        /* 4 depends on */ {},
        /* 5 depends on */ {}
    };

    topo_sort(adj).for_each([](auto i)
    {
        std::wcout << i << std::endl;
    });

    return 0;
}
#endif