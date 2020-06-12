/* SPDX Apache */
/* (c) 2020 Roman Stratiienko r.stratiienko@gmail.com */

#define N(...) __VA_ARGS__
#define Q() \"

#define BO() "${
#define BOQ() "\${
#define BC() }"

#define EXTENV(var_name, extension) setenv var_name BO()N(var_name)BC()N(extension)
#define FEXTENV(var_name, extension) setenv var_name BOQ()N(var_name)BC()N(extension)

#define FUNC_BEGIN(name) setenv name '
#define FUNC_END() '

#define STRESC(...) Q()N(__VA_ARGS__)Q()

