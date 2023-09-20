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
static const char *ng0 = "/home/elebihan/enseeiht/architecture/s7/tp1-simulation/additionneur.vhd";



static void work_a_1429900919_2493878137_p_0(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    int t6;
    int t7;
    char *t8;
    int64 t9;
    int64 t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;

LAB0:    xsi_set_current_line(85, ng0);
    t1 = (t0 + 2328U);
    t2 = *((char **)t1);
    t1 = (t2 + 0);
    *((int *)t1) = 0;
    xsi_set_current_line(86, ng0);
    t1 = (t0 + 1032U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)3);
    if (t4 != 0)
        goto LAB2;

LAB4:
LAB3:    xsi_set_current_line(90, ng0);
    t1 = (t0 + 1192U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)3);
    if (t4 != 0)
        goto LAB5;

LAB7:
LAB6:    xsi_set_current_line(94, ng0);
    t1 = (t0 + 1352U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)3);
    if (t4 != 0)
        goto LAB8;

LAB10:
LAB9:    xsi_set_current_line(99, ng0);
    t1 = (t0 + 1968U);
    t2 = *((char **)t1);
    t9 = *((int64 *)t2);
    t10 = (2 * t9);
    t1 = (t0 + 2088U);
    t5 = *((char **)t1);
    t1 = (t0 + 2328U);
    t8 = *((char **)t1);
    t6 = *((int *)t8);
    t7 = (t6 - 0);
    t11 = (t7 * 1);
    xsi_vhdl_check_range_of_index(0, 3, 1, t6);
    t12 = (1U * t11);
    t13 = (0 + t12);
    t1 = (t5 + t13);
    t3 = *((unsigned char *)t1);
    t14 = (t0 + 3704);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    *((unsigned char *)t18) = t3;
    xsi_driver_first_trans_delta(t14, 0U, 1, t10);
    t19 = (t0 + 3704);
    xsi_driver_intertial_reject(t19, t10, t10);
    xsi_set_current_line(100, ng0);
    t1 = (t0 + 1968U);
    t2 = *((char **)t1);
    t9 = *((int64 *)t2);
    t10 = (3 * t9);
    t1 = (t0 + 2208U);
    t5 = *((char **)t1);
    t1 = (t0 + 2328U);
    t8 = *((char **)t1);
    t6 = *((int *)t8);
    t7 = (t6 - 0);
    t11 = (t7 * 1);
    xsi_vhdl_check_range_of_index(0, 3, 1, t6);
    t12 = (1U * t11);
    t13 = (0 + t12);
    t1 = (t5 + t13);
    t3 = *((unsigned char *)t1);
    t14 = (t0 + 3768);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    *((unsigned char *)t18) = t3;
    xsi_driver_first_trans_delta(t14, 0U, 1, t10);
    t19 = (t0 + 3768);
    xsi_driver_intertial_reject(t19, t10, t10);
    t1 = (t0 + 3624);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(87, ng0);
    t1 = (t0 + 2328U);
    t5 = *((char **)t1);
    t6 = *((int *)t5);
    t7 = (t6 + 1);
    t1 = (t0 + 2328U);
    t8 = *((char **)t1);
    t1 = (t8 + 0);
    *((int *)t1) = t7;
    goto LAB3;

LAB5:    xsi_set_current_line(91, ng0);
    t1 = (t0 + 2328U);
    t5 = *((char **)t1);
    t6 = *((int *)t5);
    t7 = (t6 + 1);
    t1 = (t0 + 2328U);
    t8 = *((char **)t1);
    t1 = (t8 + 0);
    *((int *)t1) = t7;
    goto LAB6;

LAB8:    xsi_set_current_line(95, ng0);
    t1 = (t0 + 2328U);
    t5 = *((char **)t1);
    t6 = *((int *)t5);
    t7 = (t6 + 1);
    t1 = (t0 + 2328U);
    t8 = *((char **)t1);
    t1 = (t8 + 0);
    *((int *)t1) = t7;
    goto LAB9;

}


extern void work_a_1429900919_2493878137_init()
{
	static char *pe[] = {(void *)work_a_1429900919_2493878137_p_0};
	xsi_register_didat("work_a_1429900919_2493878137", "isim/test_additionneur_isim_beh.exe.sim/work/a_1429900919_2493878137.didat");
	xsi_register_executes(pe);
}
