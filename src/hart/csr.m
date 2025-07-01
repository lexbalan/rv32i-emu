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

public const csr_mcycle_adr = 0xB00
public const csr_minstret_adr = 0xB02
public const csr_mcycleh_adr = 0xB80
public const csr_minstreth_adr = 0xB82

public const csr_mvendorid_adr = 0xF11
public const csr_marchid_adr = 0xF12
public const csr_mimpid_adr = 0xF13
public const csr_mhartid_adr = 0xF14
public const csr_mconfigptr_adr = 0xF15



// MISA fields
public const csr_misa_a = Word32 1 << 0
public const csr_misa_b = Word32 1 << 1
public const csr_misa_c = Word32 1 << 2
public const csr_misa_f = Word32 1 << 5
public const csr_misa_i = Word32 1 << 8
public const csr_misa_m = Word32 1 << 12
public const csr_misa_s = Word32 1 << 18
public const csr_misa_u = Word32 1 << 20
public const csr_misa_x = Word32 1 << 23
public const csr_misa_xlen_32 = Word32 1 << 30
public const csr_misa_xlen_64 = Word32 2 << 30


