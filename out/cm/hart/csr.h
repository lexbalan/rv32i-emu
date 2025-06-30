/*
 * hart/csr
 */

#ifndef CSR_H
#define CSR_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>


#define csr_csr_mstatus_adr  0x300
#define csr_csr_misa_adr  0x301
#define csr_csr_medeleg_adr  0x302
#define csr_csr_mideleg_adr  0x303
#define csr_csr_mie_adr  0x304
#define csr_csr_mtvec_adr  0x305
#define csr_csr_mcounteren_adr  0x306
#define csr_csr_mscratch_adr  0x340
#define csr_csr_mepc_adr  0x341
#define csr_csr_mcause_adr  0x342
#define csr_csr_mtval_adr  0x343
#define csr_csr_mip_adr  0x344

#define csr_csr_mhartid_adr  0xF14
#define csr_csr_mcycle_adr  0xB00
#define csr_csr_mcycleh_adr  0xB80

#define csr_csr_sstatus_adr  0x100
#define csr_csr_sie_adr  0x104
#define csr_csr_stvec_adr  0x105
#define csr_csr_scause_adr  0x142
#define csr_csr_stval_adr  0x143
#define csr_csr_sip_adr  0x144
#define csr_csr_satp_adr  0x180
#define csr_csr_misa_a  (0x1 << 0)
#define csr_csr_misa_b  (0x1 << 1)
#define csr_csr_misa_c  (0x1 << 2)
#define csr_csr_misa_f  (0x1 << 5)
#define csr_csr_misa_i  (0x1 << 8)
#define csr_csr_misa_m  (0x1 << 12)
#define csr_csr_misa_s  (0x1 << 18)
#define csr_csr_misa_u  (0x1 << 20)
#define csr_csr_misa_x  (0x1 << 23)
#define csr_csr_misa_xlen_32  (0x1 << 30)
#define csr_csr_misa_xlen_64  (0x2 << 30)

#endif /* CSR_H */
