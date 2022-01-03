
#ifndef UTILS
#define UTILS

#define R_NO_REMAP

#include <R.h>
#include <Rinternals.h>

#include <cstdlib>

#define SWAP(x) swap_bytes(&x, sizeof(x));

extern "C" {

	void swap_bytes(void * pntr, size_t n);

}

// index types

typedef ptrdiff_t index_t;

typedef double Rindex_t;

#define INDEX_PTR(x) ((Rindex_t *)(DATAPTR(x)))

// pair structure

template<typename T1, typename T2>
struct Pair {
	T1 first;
	T2 second;
};

// function templates

template<typename T>
T * DataPtr(SEXP x);

template<typename T>
T DataElt(SEXP x, size_t i);

template<typename T>
void SetDataElt(SEXP x, size_t i, T value);

template<typename T>
T DataNA();

template<typename T>
bool IsNA(T x);

#endif // UTILS
