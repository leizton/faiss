#include <bits/stdc++.h>

#include <faiss/c_api/AutoTune_c.h>
#include <faiss/c_api/Index_c.h>
#include <faiss/c_api/index_factory_c.h>

using namespace std;

struct StdOutStream {
  ~StdOutStream() { out_ << '\n'; std::cout << out_.str() << std::flush; }
  template <typename T> StdOutStream& operator<<(const T& t) { out_ << t; return *this; }
  std::ostringstream out_;
};

#define LOG() StdOutStream() << "[" << __FILE__ << ":" << __LINE__ << ", " << __FUNCTION__ << "] "

std::string float2Str(float f, int precision) {
  std::ostringstream s;
  s << std::fixed << std::setprecision(precision) << f;
  return s.str();
}

string VecToStr(const vector<float>& mat, int dim, int idx) {
  string s;
  s += '[';
  int p = idx * dim;
  for (int i = 0; i < dim; i++, p++) {
    if (i != 0) s += ',';
    s += float2Str(mat[p], 4);
  }
  s += ']';
  return s;
}

void NormVector(vector<float>& mat, int dim) {
  int n = int(mat.size()) / dim;
  for (int i = 0; i < n; i++) {
    float sum = 0;
    for (int j = 0; j < dim; j++) {
      float t = mat[i * dim + j];
      sum += t * t;
    }
    if (sum < 1e-7) continue;
    sum = sqrt(sum);
    for (int j = 0; j < dim; j++) {
      mat[i * dim + j] /= sum;
    }
  }
}

int main() {
  const int dim = 3;
  vector<float> index_vectors = {  // 检索向量
    1, 1, 1,
    1, 2, 3,
    -1, -1, -1,
    -1, -2, -3,
  };
  vector<float> query_vectors = {  // 查询向量
    10, 10, 10,
    5, 10, 15,
    5, 15, 45,
    -10, -10, -10,
    -5, -10, -15,
  };
  NormVector(index_vectors, dim);
  NormVector(query_vectors, dim);
  const int index_num = int(index_vectors.size()) / dim;
  for (int i = 0; i < index_num; i++) {
    LOG() << "index_" << i << " " << VecToStr(index_vectors, dim, i);
  }
  LOG() << "";

  // build faiss index
  FaissIndex* index = nullptr;
  if (faiss_index_factory(&index, dim, "HNSW4,Flat", METRIC_INNER_PRODUCT)) {
    LOG() << "create index fail";
    return 1;
  }
  if (faiss_Index_add(index, index_num, index_vectors.data())) {
    LOG() << "init index fail";
    return -1;
  }
  LOG() << "index size: " << faiss_Index_ntotal(index);

  // search
  int topk = 2;
  const int query_num = int(query_vectors.size()) / dim;
  vector<idx_t> sim_index(query_num * topk, 0);  // 相似向量的下标索引
  vector<float> sim_score(query_num * topk, 0);  // 相似分
  if (faiss_Index_search(index, query_num, query_vectors.data(), topk, sim_score.data(), sim_index.data())) {
    LOG() << "search fail";
    return -1;
  }
  for (int i = 0; i < query_num; i++) {
    LOG() << "query_" << i << " " << VecToStr(query_vectors, dim, i);
    for (int j = 0; j < topk; j++) {
      int p = i * topk + j;
      LOG() << "    index=" << sim_index[p]
            << " score=" << sim_score[p]
            << " vec=" << VecToStr(index_vectors, dim, sim_index[p]);
    }
  }

  faiss_Index_free(index);
  return 0;
}
