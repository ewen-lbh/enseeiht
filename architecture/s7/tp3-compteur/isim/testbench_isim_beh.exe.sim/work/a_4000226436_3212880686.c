/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/elebihan/enseeiht/architecture/s7/tp3-compteur/counter.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_3620187407;

unsigned char ieee_p_2592010699_sub_2763492388968962707_503743352(char *, char *, unsigned int , unsigned int );
char *ieee_p_3620187407_sub_2255506239096166994_3965413181(char *, char *, char *, char *, int );
unsigned char ieee_p_3620187407_sub_970019341842465249_3965413181(char *, char *, char *, int );


static void work_a_4000226436_3212880686_p_0(char *t0)
{
    char t9[16];
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t10;
    unsigned int t11;
    unsigned int t12;

LAB0:    xsi_set_current_line(48, ng0);
    t1 = (t0 + 1192U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)2);
    if (t4 != 0)
        goto LAB2;

LAB4:    t1 = (t0 + 992U);
    t3 = ieee_p_2592010699_sub_2763492388968962707_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t3 != 0)
        goto LAB5;

LAB6:
LAB3:    t1 = (t0 + 3104);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(49, ng0);
    t1 = xsi_get_transient_memory(4U);
    memset(t1, 0, 4U);
    t5 = t1;
    memset(t5, (unsigned char)2, 4U);
    t6 = (t0 + 1808U);
    t7 = *((char **)t6);
    t6 = (t7 + 0);
    memcpy(t6, t1, 4U);
    xsi_set_current_line(50, ng0);
    t1 = (t0 + 1808U);
    t2 = *((char **)t1);
    t1 = (t0 + 3184);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 4U);
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(51, ng0);
    t1 = (t0 + 3248);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    goto LAB3;

LAB5:    xsi_set_current_line(53, ng0);
    t2 = (t0 + 1808U);
    t5 = *((char **)t2);
    t2 = (t0 + 5104U);
    t6 = ieee_p_3620187407_sub_2255506239096166994_3965413181(IEEE_P_3620187407, t9, t5, t2, 1);
    t7 = (t0 + 1808U);
    t8 = *((char **)t7);
    t7 = (t8 + 0);
    t10 = (t9 + 12U);
    t11 = *((unsigned int *)t10);
    t12 = (1U * t11);
    memcpy(t7, t6, t12);
    xsi_set_current_line(54, ng0);
    t1 = (t0 + 1808U);
    t2 = *((char **)t1);
    t1 = (t0 + 3184);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 4U);
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(55, ng0);
    t1 = (t0 + 1808U);
    t2 = *((char **)t1);
    t1 = (t0 + 5104U);
    t3 = ieee_p_3620187407_sub_970019341842465249_3965413181(IEEE_P_3620187407, t2, t1, 0);
    if (t3 != 0)
        goto LAB7;

LAB9:    xsi_set_current_line(58, ng0);
    t1 = (t0 + 3248);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);

LAB8:    goto LAB3;

LAB7:    xsi_set_current_line(56, ng0);
    t5 = (t0 + 3248);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t5);
    goto LAB8;

}


extern void work_a_4000226436_3212880686_init()
{
	static char *pe[] = {(void *)work_a_4000226436_3212880686_p_0};
	xsi_register_didat("work_a_4000226436_3212880686", "isim/testbench_isim_beh.exe.sim/work/a_4000226436_3212880686.didat");
	xsi_register_executes(pe);
}
