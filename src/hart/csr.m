/*
 * hart/csr
 */

//
// CSR's
// see: https://five-embeddev.com/riscv-isa-manual/latest/priv-csrs.html
//

public const csr_mstatus_adr = 0x300     // Machine status register
public const csr_misa_adr = 0x301        // ISA and extensions
public const csr_medeleg_adr = 0x302     // Machine exception delegation register
public const csr_mideleg_adr = 0x303     // Machine interrupt delegation register
public const csr_mie_adr = 0x304         // Machine interrupt-enable register
public const csr_mtvec_adr = 0x305       // Machine trap-handler base address
public const csr_mcounteren_adr = 0x306  // Machine counter enable
public const csr_mscratch_adr = 0x340
public const csr_mepc_adr = 0x341
public const csr_mcause_adr = 0x342
public const csr_mtval_adr = 0x343
public const csr_mip_adr = 0x344

public const csr_mhartid_adr = 0xF14
public const csr_mcycle_adr = 0xB00
public const csr_mcycleh_adr = 0xB80

public const csr_sstatus_adr = 0x100
public const csr_sie_adr = 0x104
public const csr_stvec_adr = 0x105
public const csr_scause_adr = 0x142
public const csr_stval_adr = 0x143
public const csr_sip_adr = 0x144
public const csr_satp_adr = 0x180


