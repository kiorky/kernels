/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20060512
 *
 * Disassembly of dsdt.dat, Sun Nov  5 13:36:54 2006
 *
 *
 * Original Table Header:
 *     Signature        "DSDT"
 *     Length           0x00003C0A (15370)
 *     Revision         0x01
 *     OEM ID           "Arima"
 *     OEM Table ID     "161F"
 *     OEM Revision     0x06040000 (100925440)
 *     Creator ID       "INTL"
 *     Creator Revision 0x20050624 (537200164)
 */
DefinitionBlock ("dsdt.aml", "DSDT", 1, "Arima", "161F", 0x06040000)
{
    Scope (_PR)
    {
        Processor (CPU0, 0x00, 0x00008010, 0x06) {}
    }

    Name (_S0, Package (0x04)
    {
        Zero, 
        Zero, 
        Zero, 
        Zero
    })
    Name (_S3, Package (0x04)
    {
        0x03, 
        0x03, 
        Zero, 
        Zero
    })
    Name (_S4, Package (0x04)
    {
        0x04, 
        0x04, 
        Zero, 
        Zero
    })
    Name (_S5, Package (0x04)
    {
        0x05, 
        0x05, 
        Zero, 
        Zero
    })
    Method (_PTS, 1, NotSerialized)
    {
        If (LEqual (Arg0, 0x05))
        {
            Store (0x95, \_SB.PCI0.ISA.BCMD)
            Store (Zero, \_SB.PCI0.ISA.SMIC)
            Sleep (0x07D0)
        }

        If (LEqual (Arg0, 0x04))
        {
            Store (0x96, \_SB.PCI0.ISA.BCMD)
            Store (Zero, \_SB.PCI0.ISA.SMIC)
            Sleep (0x03E8)
        }

        If (LEqual (Arg0, 0x03))
        {
            Store (0x81, \_SB.PCI0.ISA.BCMD)
            Store (Zero, \_SB.PCI0.ISA.SMIC)
            Store (One, \_SB.PCI0.CRD0.PMST)
            Sleep (0x07D0)
        }
    }

    Method (_WAK, 1, NotSerialized)
    {
        If (LEqual (Arg0, 0x05))
        {
            Store (One, \_SB.PCI0.ISA.EC.ACPI)
        }

        If (LEqual (Arg0, 0x04))
        {
            Store (One, \_SB.PCI0.ISA.EC.ACPI)
            Notify (\_SB.PWRB, 0x02)
        }

        If (LEqual (Arg0, 0x03))
        {
            Store (0x82, \_SB.PCI0.ISA.BCMD)
            Store (Zero, \_SB.PCI0.ISA.SMIC)
            Store (0x97, \_SB.PCI0.ISA.BCMD)
            Store (Zero, \_SB.PCI0.ISA.SMIC)
            If (LEqual (\_GPE.GPEF, One))
            {
                Notify (\_SB.PWRB, 0x02)
            }
        }

        Store (Zero, \_GPE.GPEF)
        Return (Package (0x02)
        {
            Zero, 
            Zero
        })
    }

    Scope (_SI)
    {
        Method (_SST, 1, NotSerialized)
        {
            If (LEqual (Arg0, One))
            {
                Store ("===== SST Working =====", Debug)
            }

            If (LEqual (Arg0, 0x02))
            {
                Store ("===== SST Waking =====", Debug)
            }

            If (LEqual (Arg0, 0x03))
            {
                Store ("===== SST Sleeping =====", Debug)
            }

            If (LEqual (Arg0, 0x04))
            {
                Store ("===== SST Sleeping S4 =====", Debug)
            }
        }
    }

    Scope (_SB)
    {
        Device (SLPB)
        {
            Name (_HID, EisaId ("PNP0C0E"))
            Name (_PRW, Package (0x02)
            {
                One, 
                0x03
            })
        }

        Device (PWRB)
        {
            Name (_HID, EisaId ("PNP0C0C"))
        }

        Device (LID)
        {
            Name (_HID, EisaId ("PNP0C0D"))
            Name (_PRW, Package (0x02)
            {
                One, 
                0x03
            })
            Method (_LID, 0, NotSerialized)
            {
                If (^^PCI0.ISA.EC.ECOK)
                {
                    If (^^PCI0.ISA.EC.LIDS)
                    {
                        Return (Zero)
                    }
                    Else
                    {
                        Return (One)
                    }
                }
                Else
                {
                    Return (Zero)
                }
            }
        }

        Scope (\_GPE)
        {
            Name (GPEF, Zero)
            Method (_L01, 0, NotSerialized)
            {
                Store (One, GPEF)
                If (Not (\_SB.PCI0.ISA.EC.Z000))
                {
                    Notify (\_SB.PCI0.ISA.KBC0, 0x80)
                }

                If (Not (\_SB.PCI0.ISA.EC.TME0))
                {
                    Notify (\_SB.PCI0.ISA.MSE0, 0x80)
                }
            }

            Method (_L09, 0, NotSerialized)
            {
                Store (One, GPEF)
                Notify (\_SB.PCI0, 0x02)
            }
        }

        Device (PCI0)
        {
            Name (_HID, EisaId ("PNP0A03"))
            Name (_ADR, Zero)
            OperationRegion (BAR1, PCI_Config, 0x14, 0x04)
            Field (BAR1, ByteAcc, NoLock, Preserve)
            {
                Z001,   32
            }

            Name (_BBN, Zero)
            OperationRegion (MREG, PCI_Config, 0xB8, 0x14)
            Field (MREG, ByteAcc, NoLock, Preserve)
            {
                CS0,    8, 
                CS1,    8, 
                CS2,    8, 
                CS3,    8, 
                        Offset (0x10), 
                FBSL,   8, 
                FBSM,   8
            }

            Method (TOM, 0, NotSerialized)
            {
                Multiply (FBSL, 0x00010000, Local0)
                Multiply (FBSM, 0x01000000, Local1)
                Add (Local0, Local1, Local0)
                Return (Local0)
            }

            OperationRegion (VGAM, SystemMemory, 0x000C0002, One)
            Field (VGAM, ByteAcc, Lock, Preserve)
            {
                VSIZ,   8
            }

            Name (RSRC, ResourceTemplate ()
            {
                WordBusNumber (ResourceProducer, MinFixed, MaxFixed, SubDecode,
                    0x0000,             // Granularity
                    0x0000,             // Range Minimum
                    0x00FF,             // Range Maximum
                    0x0000,             // Translation Offset
                    0x0100,             // Length
                    ,, )
                DWordMemory (ResourceProducer, SubDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000A0000,         // Range Minimum
                    0x000BFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00020000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, SubDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x00100000,         // Range Minimum
                    0xFFFDFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0xFFEE0000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                IO (Decode16,
                    0x0CF8,             // Range Minimum
                    0x0CF8,             // Range Maximum
                    0x01,               // Alignment
                    0x08,               // Length
                    )
                WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                    0x0000,             // Granularity
                    0x0000,             // Range Minimum
                    0x0CF7,             // Range Maximum
                    0x0000,             // Translation Offset
                    0x0CF8,             // Length
                    ,, , TypeStatic)
                WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                    0x0000,             // Granularity
                    0x0D00,             // Range Minimum
                    0xFFFF,             // Range Maximum
                    0x0000,             // Translation Offset
                    0xF300,             // Length
                    ,, , TypeStatic)
            })
            Method (_CRS, 0, Serialized)
            {
                CreateDWordField (RSRC, 0x1F, VMAX)
                CreateDWordField (RSRC, 0x27, VLEN)
                ShiftLeft (VSIZ, 0x09, Local0)
                Add (Local0, 0x000BFFFF, VMAX)
                Add (Local0, 0x00020000, VLEN)
                CreateDWordField (RSRC, 0x36, BTMN)
                CreateDWordField (RSRC, 0x3A, BTMX)
                CreateDWordField (RSRC, 0x42, BTLN)
                Store (TOM (), BTMN)
                Subtract (0xFFF80000, BTMN, BTLN)
                Subtract (Add (BTMN, BTLN), One, BTMX)
                Return (RSRC)
            }

            OperationRegion (ECSM, SystemMemory, 0x0BEFFD4D, 0x0200)
            Field (ECSM, AnyAcc, NoLock, Preserve)
            {
                ADP,    1, 
                    ,   1, 
                BATP,   1, 
                    ,   1, 
                BATL,   1, 
                BATC,   1, 
                        Offset (0x01), 
                BDC,    32, 
                BFC,    32, 
                BTC,    32, 
                BDV,    32, 
                BST,    32, 
                BPR,    32, 
                BRC,    32, 
                BPV,    32, 
                BCW,    32, 
                BCL,    32, 
                BCG,    32, 
                BG2,    32, 
                BMO,    32, 
                BSN0,   32, 
                BSN1,   32, 
                BTY0,   8, 
                BTY1,   8, 
                BTY2,   8, 
                BTY3,   8, 
                NABT,   8, 
                TMP,    16, 
                ECOK,   8
            }

            Method (_STA, 0, NotSerialized)
            {
                Return (0x0F)
            }

            Name (_PRT, Package (0x0E)
            {
                Package (0x04)
                {
                    0x000EFFFF, 
                    Zero, 
                    ISA.LNK2, 
                    Zero
                }, 

                Package (0x04)
                {
                    0x000EFFFF, 
                    One, 
                    ISA.LNK3, 
                    Zero
                }, 

                Package (0x04)
                {
                    0x000EFFFF, 
                    0x02, 
                    ISA.LNK0, 
                    Zero
                }, 

                Package (0x04)
                {
                    0x000EFFFF, 
                    0x03, 
                    ISA.LNK1, 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0008FFFF, 
                    Zero, 
                    ISA.LNK6, 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0004FFFF, 
                    Zero, 
                    ISA.LNK7, 
                    Zero
                }, 

                Package (0x04)
                {
                    0x000AFFFF, 
                    Zero, 
                    ISA.LNK2, 
                    Zero
                }, 

                Package (0x04)
                {
                    0x000AFFFF, 
                    One, 
                    ISA.LNK1, 
                    Zero
                }, 

                Package (0x04)
                {
                    0x000BFFFF, 
                    Zero, 
                    ISA.LNK1, 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0013FFFF, 
                    Zero, 
                    ISA.LNK3, 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0013FFFF, 
                    One, 
                    ISA.LNK3, 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0013FFFF, 
                    0x02, 
                    ISA.LNK3, 
                    Zero
                }, 

                Package (0x04)
                {
                    0x000CFFFF, 
                    Zero, 
                    ISA.LNK1, 
                    Zero
                }, 

                Package (0x04)
                {
                    0x000CFFFF, 
                    One, 
                    ISA.LNK0, 
                    Zero
                }
            })
            Device (ISA)
            {
                Name (_ADR, 0x00070000)
                Mutex (PSMX, 0x00)
                OperationRegion (PUSB, PCI_Config, 0x74, One)
                Field (PUSB, ByteAcc, NoLock, Preserve)
                {
                    PIR8,   4, 
                            Offset (0x01)
                }

                OperationRegion (PIRX, PCI_Config, 0x48, 0x04)
                Field (PIRX, ByteAcc, NoLock, Preserve)
                {
                    PIR0,   4, 
                    PIR1,   4, 
                    PIR2,   4, 
                    PIR3,   4, 
                    PIR4,   4, 
                    PIR5,   4, 
                    PIR6,   4, 
                    PIR7,   4
                }

                Name (IPRS, ResourceTemplate ()
                {
                    IRQ (Level, ActiveLow, Shared, )
                        {3,4,5,6,7,10,11,12}
                })
                Name (IXLT, Package (0x10)
                {
                    Zero, 
                    0x0200, 
                    0x08, 
                    0x0400, 
                    0x10, 
                    0x20, 
                    0x80, 
                    0x40, 
                    0x02, 
                    0x0800, 
                    Zero, 
                    0x1000, 
                    Zero, 
                    0x4000, 
                    Zero, 
                    0x8000
                })
                Device (LNK0)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, One)
                    Method (_STA, 0, NotSerialized)
                    {
                        If (PIR0)
                        {
                            Return (0x0B)
                        }
                        Else
                        {
                            Return (0x09)
                        }
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {5,6}
                    })
                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (Zero, PIR0)
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Store (IPRS, Local0)
                        CreateWordField (Local0, One, IRA0)
                        Store (PIR0, Local1)
                        Store (DerefOf (Index (IXLT, Local1)), IRA0)
                        Return (Local0)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        CreateWordField (Arg0, One, IRA0)
                        Store (Match (IXLT, MEQ, IRA0, MGT, Zero, Zero), PIR0)
                    }
                }

                Device (LNK1)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x02)
                    Method (_STA, 0, NotSerialized)
                    {
                        If (PIR1)
                        {
                            Return (0x0B)
                        }
                        Else
                        {
                            Return (0x09)
                        }
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {8,10}
                    })
                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (Zero, PIR1)
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Store (IPRS, Local0)
                        CreateWordField (Local0, One, IRA0)
                        Store (PIR1, Local1)
                        Store (DerefOf (Index (IXLT, Local1)), IRA0)
                        Return (Local0)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        CreateWordField (Arg0, One, IRA0)
                        Store (Match (IXLT, MEQ, IRA0, MGT, Zero, Zero), PIR1)
                    }
                }

                Device (LNK2)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x03)
                    Method (_STA, 0, NotSerialized)
                    {
                        If (PIR2)
                        {
                            Return (0x0B)
                        }
                        Else
                        {
                            Return (0x09)
                        }
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {11}
                    })
                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (Zero, PIR2)
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Store (IPRS, Local0)
                        CreateWordField (Local0, One, IRA0)
                        Store (PIR2, Local1)
                        Store (DerefOf (Index (IXLT, Local1)), IRA0)
                        Return (Local0)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        CreateWordField (Arg0, One, IRA0)
                        Store (Match (IXLT, MEQ, IRA0, MGT, Zero, Zero), PIR2)
                    }
                }

                Device (LNK3)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x04)
                    Method (_STA, 0, NotSerialized)
                    {
                        If (PIR3)
                        {
                            Return (0x0B)
                        }
                        Else
                        {
                            Return (0x09)
                        }
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {6,7,10,13}
                    })
                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (Zero, PIR3)
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Store (IPRS, Local0)
                        CreateWordField (Local0, One, IRA0)
                        Store (PIR3, Local1)
                        Store (DerefOf (Index (IXLT, Local1)), IRA0)
                        Return (Local0)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        CreateWordField (Arg0, One, IRA0)
                        Store (Match (IXLT, MEQ, IRA0, MGT, Zero, Zero), PIR3)
                    }
                }

                Device (LNK4)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x05)
                    Method (_STA, 0, NotSerialized)
                    {
                        If (PIR4)
                        {
                            Return (0x0B)
                        }
                        Else
                        {
                            Return (0x09)
                        }
                    }

                    Method (_PRS, 0, NotSerialized)
                    {
                        Return (IPRS)
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (Zero, PIR4)
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Store (IPRS, Local0)
                        CreateWordField (Local0, One, IRA0)
                        Store (PIR4, Local1)
                        Store (DerefOf (Index (IXLT, Local1)), IRA0)
                        Return (Local0)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        CreateWordField (Arg0, One, IRA0)
                        Store (Match (IXLT, MEQ, IRA0, MGT, Zero, Zero), PIR4)
                    }
                }

                Device (LNK5)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x06)
                    Method (_STA, 0, NotSerialized)
                    {
                        If (PIR5)
                        {
                            Return (0x0B)
                        }
                        Else
                        {
                            Return (0x09)
                        }
                    }

                    Method (_PRS, 0, NotSerialized)
                    {
                        Return (IPRS)
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (Zero, PIR5)
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Store (IPRS, Local0)
                        CreateWordField (Local0, One, IRA0)
                        Store (PIR5, Local1)
                        Store (DerefOf (Index (IXLT, Local1)), IRA0)
                        Return (Local0)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        CreateWordField (Arg0, One, IRA0)
                        Store (Match (IXLT, MEQ, IRA0, MGT, Zero, Zero), PIR5)
                    }
                }

                Device (LNK6)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x07)
                    Method (_STA, 0, NotSerialized)
                    {
                        If (PIR6)
                        {
                            Return (0x0B)
                        }
                        Else
                        {
                            Return (0x09)
                        }
                    }

                    Method (_PRS, 0, NotSerialized)
                    {
                        Return (IPRS)
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (Zero, PIR6)
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Store (IPRS, Local0)
                        CreateWordField (Local0, One, IRA0)
                        Store (PIR6, Local1)
                        Store (DerefOf (Index (IXLT, Local1)), IRA0)
                        Return (Local0)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        CreateWordField (Arg0, One, IRA0)
                        Store (Match (IXLT, MEQ, IRA0, MGT, Zero, Zero), PIR6)
                    }
                }

                Device (LNK7)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x08)
                    Method (_STA, 0, NotSerialized)
                    {
                        If (PIR7)
                        {
                            Return (0x0B)
                        }
                        Else
                        {
                            Return (0x09)
                        }
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {5}
                    })
                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (Zero, PIR7)
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Store (IPRS, Local0)
                        CreateWordField (Local0, One, IRA0)
                        Store (PIR7, Local1)
                        Store (DerefOf (Index (IXLT, Local1)), IRA0)
                        Return (Local0)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        CreateWordField (Arg0, One, IRA0)
                        Store (Match (IXLT, MEQ, IRA0, MGT, Zero, Zero), PIR7)
                    }
                }

                Device (LNK8)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x09)
                    Method (_STA, 0, NotSerialized)
                    {
                        If (PIR8)
                        {
                            Return (0x0B)
                        }
                        Else
                        {
                            Return (0x09)
                        }
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {5}
                    })
                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (Zero, PIR8)
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Store (IPRS, Local0)
                        CreateWordField (Local0, One, IRA0)
                        Store (PIR8, Local1)
                        Store (DerefOf (Index (IXLT, Local1)), IRA0)
                        Return (Local0)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        CreateWordField (Arg0, One, IRA0)
                        Store (Match (IXLT, MEQ, IRA0, MGT, Zero, Zero), PIR8)
                    }
                }

                Device (DMAC)
                {
                    Name (_HID, EisaId ("PNP0200"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x01,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x0081,             // Range Minimum
                            0x0081,             // Range Maximum
                            0x01,               // Alignment
                            0x0F,               // Length
                            )
                        IO (Decode16,
                            0x00C0,             // Range Minimum
                            0x00C0,             // Range Maximum
                            0x01,               // Alignment
                            0x20,               // Length
                            )
                        DMA (Compatibility, NotBusMaster, Transfer8_16, )
                            {4}
                    })
                }

                Device (PIC)
                {
                    Name (_HID, EisaId ("PNP0000"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0020,             // Range Minimum
                            0x0020,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A0,             // Range Minimum
                            0x00A0,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IRQ (Edge, ActiveHigh, Exclusive, )
                            {2}
                    })
                }

                Device (TIME)
                {
                    Name (_HID, EisaId ("PNP0100"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0040,             // Range Minimum
                            0x0040,             // Range Maximum
                            0x01,               // Alignment
                            0x04,               // Length
                            )
                        IRQ (Edge, ActiveHigh, Exclusive, )
                            {0}
                    })
                }

                Device (RTC)
                {
                    Name (_HID, EisaId ("PNP0B00"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0070,             // Range Minimum
                            0x0070,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IRQ (Edge, ActiveHigh, Exclusive, )
                            {8}
                    })
                }

                Device (MATH)
                {
                    Name (_HID, EisaId ("PNP0C04"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x00F0,             // Range Minimum
                            0x00F0,             // Range Maximum
                            0x01,               // Alignment
                            0x0F,               // Length
                            )
                        IRQ (Edge, ActiveHigh, Exclusive, )
                            {13}
                    })
                }

                Device (SPKR)
                {
                    Name (_HID, EisaId ("PNP0800"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0061,             // Range Minimum
                            0x0061,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                    })
                }

                Device (KBC0)
                {
                    Name (_HID, EisaId ("PNP0303"))
                    Name (_PRW, Package (0x02)
                    {
                        0x06, 
                        0x03
                    })
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0060,             // Range Minimum
                            0x0060,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0064,             // Range Minimum
                            0x0064,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IRQ (Edge, ActiveHigh, Exclusive, )
                            {1}
                    })
                    Method (_PSW, 1, NotSerialized)
                    {
                        If (Arg0)
                        {
                            If (^^EC.ECOK)
                            {
                                Store (One, ^^EC.Z000)
                            }
                        }
                        Else
                        {
                            If (^^EC.ECOK)
                            {
                                Store (Zero, ^^EC.Z000)
                            }
                        }
                    }
                }

                Device (MSE0)
                {
                    Name (_HID, EisaId ("SYN0002"))
                    Name (_CID, 0x130FD041)
                    Name (_CRS, ResourceTemplate ()
                    {
                        IRQ (Edge, ActiveHigh, Exclusive, )
                            {12}
                    })
                    Method (_PSW, 1, NotSerialized)
                    {
                        If (Arg0)
                        {
                            If (^^EC.ECOK)
                            {
                                Store (One, ^^EC.TME0)
                            }
                        }
                        Else
                        {
                            If (^^EC.ECOK)
                            {
                                Store (Zero, ^^EC.TME0)
                            }
                        }
                    }
                }

                Device (SYSR)
                {
                    Name (_HID, EisaId ("PNP0C02"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0073,             // Range Minimum
                            0x0073,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0080,             // Range Minimum
                            0x0080,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x00B0,             // Range Minimum
                            0x00B0,             // Range Maximum
                            0x01,               // Alignment
                            0x04,               // Length
                            )
                        IO (Decode16,
                            0x0092,             // Range Minimum
                            0x0092,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0200,             // Range Minimum
                            0x0200,             // Range Maximum
                            0x01,               // Alignment
                            0x08,               // Length
                            )
                        IO (Decode16,
                            0x040B,             // Range Minimum
                            0x040B,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0480,             // Range Minimum
                            0x0480,             // Range Maximum
                            0x01,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x04D0,             // Range Minimum
                            0x04D0,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x04D6,             // Range Minimum
                            0x04D6,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x8000,             // Range Minimum
                            0x8000,             // Range Maximum
                            0x01,               // Alignment
                            0x80,               // Length
                            )
                        IO (Decode16,
                            0xF500,             // Range Minimum
                            0xF500,             // Range Maximum
                            0x01,               // Alignment
                            0x04,               // Length
                            )
                    })
                }

                Device (MEM)
                {
                    Name (_HID, EisaId ("PNP0C01"))
                    Name (MSRC, ResourceTemplate ()
                    {
                        Memory32Fixed (ReadWrite,
                            0x00000000,         // Address Base
                            0x000A0000,         // Address Length
                            )
                        Memory32Fixed (ReadOnly,
                            0x000DC000,         // Address Base
                            0x00004000,         // Address Length
                            )
                        Memory32Fixed (ReadOnly,
                            0x000C0000,         // Address Base
                            0x0000F000,         // Address Length
                            )
                        Memory32Fixed (ReadOnly,
                            0x000E0000,         // Address Base
                            0x00020000,         // Address Length
                            )
                        Memory32Fixed (ReadWrite,
                            0x00100000,         // Address Base
                            0x07F00000,         // Address Length
                            _X00)
                        Memory32Fixed (ReadOnly,
                            0xFFF80000,         // Address Base
                            0x00080000,         // Address Length
                            )
                        Memory32Fixed (ReadWrite,
                            0x00000000,         // Address Base
                            0x00000000,         // Address Length
                            _X01)
                    })
                    Method (_CRS, 0, NotSerialized)
                    {
                        CreateDWordField (MSRC, \_SB.PCI0.ISA.MEM._X00._LEN, EMLN)
                        Subtract (TOM (), 0x00100000, EMLN)
                        CreateDWordField (MSRC, \_SB.PCI0.ISA.MEM._X01._BAS, BARX)
                        CreateDWordField (MSRC, \_SB.PCI0.ISA.MEM._X01._LEN, GALN)
                        Store (0x1000, GALN)
                        Store (Z001, Local0)
                        And (Local0, 0xFFFFFFF0, BARX)
                        Return (MSRC)
                    }

                    Method (_STA, 0, NotSerialized)
                    {
                        Return (0x0F)
                    }
                }

                OperationRegion (SMI0, SystemIO, 0xF500, 0x02)
                Field (SMI0, AnyAcc, NoLock, Preserve)
                {
                    SMIC,   8
                }

                OperationRegion (SMI1, SystemMemory, 0x0BEFFD4D, 0x0200)
                Field (SMI1, AnyAcc, NoLock, Preserve)
                {
                    BCMD,   8, 
                    DID,    32, 
                    INFO,   1024
                }

                Field (SMI1, AnyAcc, NoLock, Preserve)
                {
                            AccessAs (ByteAcc, 0x00), 
                            Offset (0x05), 
                    INF,    8
                }

                Device (SIOD)
                {
                    Name (_HID, EisaId ("PNP0A05"))
                    OperationRegion (SIIO, SystemIO, 0x0370, 0x02)
                    Field (SIIO, ByteAcc, NoLock, Preserve)
                    {
                        INDX,   8, 
                        DATA,   8
                    }

                    IndexField (INDX, DATA, ByteAcc, NoLock, Preserve)
                    {
                                Offset (0x22), 
                        CR22,   8, 
                                Offset (0x30), 
                        CR30,   8, 
                                Offset (0x60), 
                        CR60,   8, 
                        CR61,   8, 
                                Offset (0x70), 
                        CR70,   8, 
                                Offset (0x74), 
                        CR74,   8, 
                                Offset (0xF0), 
                        CRF0,   8, 
                        CRF1,   8, 
                        CRF2,   8, 
                                Offset (0xF4), 
                        CRF4,   8, 
                        CRF5,   8
                    }

                    Method (ENFG, 1, NotSerialized)
                    {
                        Acquire (MTIO, 0xFFFF)
                        Store (0x51, INDX)
                        Store (0x23, INDX)
                        Store (0x07, INDX)
                        Store (Arg0, DATA)
                    }

                    Method (EXFG, 0, NotSerialized)
                    {
                        Store (0xBB, INDX)
                        Release (MTIO)
                    }

                    Device (FDC)
                    {
                        Name (_HID, EisaId ("PNP0700"))
                        Method (_STA, 0, NotSerialized)
                        {
                            ENFG (Zero)
                            And (CR30, One, Local0)
                            And (CR60, 0x03, Local1)
                            EXFG ()
                            If (LAnd (Local0, Local1))
                            {
                                Return (0x0F)
                            }
                            Else
                            {
                                Return (0x0D)
                            }
                        }

                        Method (_DIS, 0, NotSerialized)
                        {
                            ENFG (Zero)
                            Store (Zero, CR30)
                            Store (Zero, CR60)
                            Store (Zero, CR61)
                            Store (0x04, CR74)
                            Store (Zero, CR70)
                            EXFG ()
                        }

                        Name (RSRC, ResourceTemplate ()
                        {
                            IO (Decode16,
                                0x03F0,             // Range Minimum
                                0x03F0,             // Range Maximum
                                0x01,               // Alignment
                                0x06,               // Length
                                _X02)
                            IO (Decode16,
                                0x03F7,             // Range Minimum
                                0x03F7,             // Range Maximum
                                0x01,               // Alignment
                                0x01,               // Length
                                _X03)
                            IRQNoFlags (_X04)
                                {6}
                            DMA (Compatibility, NotBusMaster, Transfer8, _X05)
                                {2}
                        })
                        Method (_CRS, 0, NotSerialized)
                        {
                            CreateWordField (RSRC, \_SB.PCI0.ISA.SIOD.FDC._X02._MIN, IO1L)
                            CreateWordField (RSRC, \_SB.PCI0.ISA.SIOD.FDC._X02._MAX, IO1H)
                            CreateWordField (RSRC, \_SB.PCI0.ISA.SIOD.FDC._X03._MIN, IO2L)
                            CreateWordField (RSRC, \_SB.PCI0.ISA.SIOD.FDC._X03._MAX, IO2H)
                            CreateWordField (RSRC, \_SB.PCI0.ISA.SIOD.FDC._X04._INT, IRQX)
                            CreateByteField (RSRC, \_SB.PCI0.ISA.SIOD.FDC._X05._DMA, DMAX)
                            Store (Zero, IO1L)
                            Store (Zero, IO1H)
                            Store (Zero, IO2L)
                            Store (Zero, IO2H)
                            Store (Zero, IRQX)
                            Store (Zero, DMAX)
                            ENFG (Zero)
                            Store (CR30, Local0)
                            Store (CR60, Local1)
                            If (LAnd (Local0, Local1))
                            {
                                Store (_PRS, RSRC)
                            }

                            EXFG ()
                            Return (RSRC)
                        }

                        Name (_PRS, ResourceTemplate ()
                        {
                            IO (Decode16,
                                0x03F0,             // Range Minimum
                                0x03F0,             // Range Maximum
                                0x01,               // Alignment
                                0x06,               // Length
                                )
                            IO (Decode16,
                                0x03F7,             // Range Minimum
                                0x03F7,             // Range Maximum
                                0x01,               // Alignment
                                0x01,               // Length
                                )
                            IRQNoFlags ()
                                {6}
                            DMA (Compatibility, NotBusMaster, Transfer8, )
                                {2}
                        })
                        Method (_SRS, 1, NotSerialized)
                        {
                            Store (Arg0, RSRC)
                            CreateWordField (RSRC, \_SB.PCI0.ISA.SIOD.FDC._X02._MIN, IOX)
                            CreateWordField (RSRC, \_SB.PCI0.ISA.SIOD.FDC._X04._INT, IRQX)
                            CreateByteField (RSRC, \_SB.PCI0.ISA.SIOD.FDC._X05._DMA, DMAX)
                            ENFG (Zero)
                            And (IOX, 0xFF, CR61)
                            ShiftRight (IOX, 0x08, CR60)
                            FindSetRightBit (IRQX, Local0)
                            If (Local0)
                            {
                                Decrement (Local0)
                            }

                            Store (Local0, CR70)
                            FindSetRightBit (DMAX, Local0)
                            If (Local0)
                            {
                                Decrement (Local0)
                            }

                            Store (Local0, CR74)
                            Store (One, CR30)
                            EXFG ()
                        }

                        Method (_PSC, 0, NotSerialized)
                        {
                            ENFG (Zero)
                            And (CR30, One, Local0)
                            EXFG ()
                            If (Local0)
                            {
                                Return (Zero)
                            }
                            Else
                            {
                                Return (0x03)
                            }
                        }

                        Method (_PS0, 0, NotSerialized)
                        {
                            ENFG (Zero)
                            Store (One, CR30)
                            EXFG ()
                        }

                        Method (_PS3, 0, NotSerialized)
                        {
                            ENFG (Zero)
                            Store (Zero, CR30)
                            EXFG ()
                        }
                    }

                    Device (LPT)
                    {
                        Method (_HID, 0, NotSerialized)
                        {
                            ENFG (0x03)
                            And (CRF0, 0x03, Local0)
                            EXFG ()
                            If (Local0)
                            {
                                Return (0x0104D041)
                            }
                            Else
                            {
                                Return (0x0004D041)
                            }
                        }

                        Method (_STA, 0, NotSerialized)
                        {
                            ENFG (0x03)
                            And (CR30, One, Local0)
                            And (CR61, 0xFC, Local1)
                            EXFG ()
                            If (LAnd (Local0, Local1))
                            {
                                Return (0x0F)
                            }
                            Else
                            {
                                Return (0x0D)
                            }
                        }

                        Method (_DIS, 0, NotSerialized)
                        {
                            ENFG (0x03)
                            Store (Zero, CR30)
                            Store (Zero, CR60)
                            Store (Zero, CR61)
                            Store (Zero, CR70)
                            Store (0x04, CR70)
                            EXFG ()
                        }

                        Name (CRSA, ResourceTemplate ()
                        {
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x08,               // Length
                                _X06)
                            IRQNoFlags (_X07)
                                {}
                        })
                        Name (CRSB, ResourceTemplate ()
                        {
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x08,               // Length
                                _X08)
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x08,               // Length
                                _X09)
                            IRQNoFlags (_X0A)
                                {}
                            DMA (Compatibility, NotBusMaster, Transfer8, _X0B)
                                {}
                        })
                        Method (_CRS, 0, NotSerialized)
                        {
                            CreateWordField (CRSA, \_SB.PCI0.ISA.SIOD.LPT._X06._MIN, IOAL)
                            CreateWordField (CRSA, \_SB.PCI0.ISA.SIOD.LPT._X06._MAX, IOAH)
                            CreateByteField (CRSA, \_SB.PCI0.ISA.SIOD.LPT._X06._LEN, LENA)
                            CreateWordField (CRSA, \_SB.PCI0.ISA.SIOD.LPT._X07._INT, IRAX)
                            Store (Zero, IOAL)
                            Store (Zero, IOAH)
                            Store (Zero, LENA)
                            Store (Zero, IRAX)
                            CreateWordField (CRSB, \_SB.PCI0.ISA.SIOD.LPT._X08._MIN, IOBL)
                            CreateWordField (CRSB, \_SB.PCI0.ISA.SIOD.LPT._X08._MAX, IOBH)
                            CreateByteField (CRSB, \_SB.PCI0.ISA.SIOD.LPT._X08._LEN, LENB)
                            CreateWordField (CRSB, \_SB.PCI0.ISA.SIOD.LPT._X09._MIN, IOCL)
                            CreateWordField (CRSB, \_SB.PCI0.ISA.SIOD.LPT._X09._MAX, IOCH)
                            CreateByteField (CRSB, \_SB.PCI0.ISA.SIOD.LPT._X09._LEN, LENC)
                            CreateWordField (CRSB, \_SB.PCI0.ISA.SIOD.LPT._X0A._INT, IRBX)
                            CreateByteField (CRSB, \_SB.PCI0.ISA.SIOD.LPT._X0B._DMA, DMAX)
                            Store (Zero, IOBL)
                            Store (Zero, IOBH)
                            Store (Zero, LENB)
                            Store (Zero, IOCL)
                            Store (Zero, IOCH)
                            Store (Zero, LENC)
                            Store (Zero, IRBX)
                            Store (Zero, DMAX)
                            ENFG (0x03)
                            Store (CR60, IOAL)
                            ShiftLeft (IOAL, 0x08, Local1)
                            Or (CR61, Local1, Local2)
                            Store (Local2, IOAL)
                            Store (Local2, IOAH)
                            Store (Local2, IOBL)
                            Store (Local2, IOBH)
                            And (CRF0, 0x02, Local0)
                            If (Local0)
                            {
                                Add (Local2, 0x0400, IOCL)
                                Add (Local2, 0x0400, IOCH)
                                If (LEqual (Local2, 0x03BC))
                                {
                                    Store (0x04, LENA)
                                    Store (0x04, LENB)
                                    Store (0x04, LENC)
                                }
                                Else
                                {
                                    Store (0x08, LENA)
                                    Store (0x08, LENB)
                                    Store (0x08, LENC)
                                }
                            }

                            Store (CR70, Local1)
                            ShiftLeft (One, Local1, IRAX)
                            ShiftLeft (One, Local1, IRBX)
                            Store (CR74, Local1)
                            ShiftLeft (One, Local1, DMAX)
                            EXFG ()
                            If (Local0)
                            {
                                Return (CRSB)
                            }
                            Else
                            {
                                Return (CRSA)
                            }
                        }

                        Name (PRSA, ResourceTemplate ()
                        {
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0378,             // Range Minimum
                                    0x0378,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0278,             // Range Minimum
                                    0x0278,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x03BC,             // Range Minimum
                                    0x03BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0378,             // Range Minimum
                                    0x0378,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0278,             // Range Minimum
                                    0x0278,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x03BC,             // Range Minimum
                                    0x03BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                            }
                            EndDependentFn ()
                        })
                        Name (PRSB, ResourceTemplate ()
                        {
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0378,             // Range Minimum
                                    0x0378,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0778,             // Range Minimum
                                    0x0778,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {0}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0278,             // Range Minimum
                                    0x0278,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0678,             // Range Minimum
                                    0x0678,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {0}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x03BC,             // Range Minimum
                                    0x03BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IO (Decode16,
                                    0x07BC,             // Range Minimum
                                    0x07BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {0}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0378,             // Range Minimum
                                    0x0378,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0778,             // Range Minimum
                                    0x0778,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {0}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0278,             // Range Minimum
                                    0x0278,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0678,             // Range Minimum
                                    0x0678,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {0}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x03BC,             // Range Minimum
                                    0x03BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IO (Decode16,
                                    0x07BC,             // Range Minimum
                                    0x07BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {0}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0378,             // Range Minimum
                                    0x0378,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0778,             // Range Minimum
                                    0x0778,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {1}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0278,             // Range Minimum
                                    0x0278,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0678,             // Range Minimum
                                    0x0678,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {1}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x03BC,             // Range Minimum
                                    0x03BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IO (Decode16,
                                    0x07BC,             // Range Minimum
                                    0x07BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {1}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0378,             // Range Minimum
                                    0x0378,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0778,             // Range Minimum
                                    0x0778,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {1}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0278,             // Range Minimum
                                    0x0278,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0678,             // Range Minimum
                                    0x0678,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {1}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x03BC,             // Range Minimum
                                    0x03BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IO (Decode16,
                                    0x07BC,             // Range Minimum
                                    0x07BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {1}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0378,             // Range Minimum
                                    0x0378,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0778,             // Range Minimum
                                    0x0778,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {2}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0278,             // Range Minimum
                                    0x0278,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0678,             // Range Minimum
                                    0x0678,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {2}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x03BC,             // Range Minimum
                                    0x03BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IO (Decode16,
                                    0x07BC,             // Range Minimum
                                    0x07BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {2}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0378,             // Range Minimum
                                    0x0378,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0778,             // Range Minimum
                                    0x0778,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {2}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0278,             // Range Minimum
                                    0x0278,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0678,             // Range Minimum
                                    0x0678,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {2}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x03BC,             // Range Minimum
                                    0x03BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IO (Decode16,
                                    0x07BC,             // Range Minimum
                                    0x07BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {2}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0378,             // Range Minimum
                                    0x0378,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0778,             // Range Minimum
                                    0x0778,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {3}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0278,             // Range Minimum
                                    0x0278,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0678,             // Range Minimum
                                    0x0678,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {3}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x03BC,             // Range Minimum
                                    0x03BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IO (Decode16,
                                    0x07BC,             // Range Minimum
                                    0x07BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IRQNoFlags ()
                                    {5}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {3}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0378,             // Range Minimum
                                    0x0378,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0778,             // Range Minimum
                                    0x0778,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {3}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x0278,             // Range Minimum
                                    0x0278,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IO (Decode16,
                                    0x0678,             // Range Minimum
                                    0x0678,             // Range Maximum
                                    0x01,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {3}
                            }
                            StartDependentFn (0x00, 0x01)
                            {
                                IO (Decode16,
                                    0x03BC,             // Range Minimum
                                    0x03BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IO (Decode16,
                                    0x07BC,             // Range Minimum
                                    0x07BC,             // Range Maximum
                                    0x01,               // Alignment
                                    0x04,               // Length
                                    )
                                IRQNoFlags ()
                                    {7}
                                DMA (Compatibility, NotBusMaster, Transfer8, )
                                    {3}
                            }
                            EndDependentFn ()
                        })
                        Method (_PRS, 0, NotSerialized)
                        {
                            ENFG (0x03)
                            And (CRF0, 0x03, Local0)
                            EXFG ()
                            If (Local0)
                            {
                                Return (PRSB)
                            }
                            Else
                            {
                                Return (PRSA)
                            }
                        }

                        Method (_SRS, 1, NotSerialized)
                        {
                            ENFG (0x03)
                            And (CRF0, 0x03, Local0)
                            If (Local0)
                            {
                                Store (Arg0, CRSB)
                                CreateWordField (CRSB, \_SB.PCI0.ISA.SIOD.LPT._X08._MIN, IOB)
                                CreateWordField (CRSB, \_SB.PCI0.ISA.SIOD.LPT._X0A._INT, IRQB)
                                CreateByteField (CRSB, \_SB.PCI0.ISA.SIOD.LPT._X0B._DMA, DMAX)
                                And (IOB, 0xFF, CR61)
                                ShiftRight (IOB, 0x08, CR60)
                                FindSetRightBit (IRQB, Local0)
                                If (Local0)
                                {
                                    Decrement (Local0)
                                }

                                Store (Local0, CR70)
                                FindSetRightBit (DMAX, Local0)
                                If (Local0)
                                {
                                    Decrement (Local0)
                                }

                                Store (Local0, CR74)
                            }
                            Else
                            {
                                Store (Arg0, CRSA)
                                CreateWordField (CRSA, \_SB.PCI0.ISA.SIOD.LPT._X06._MIN, IOA)
                                CreateWordField (CRSA, \_SB.PCI0.ISA.SIOD.LPT._X07._INT, IRQA)
                                And (IOA, 0xFF, CR61)
                                ShiftRight (IOA, 0x08, CR60)
                                FindSetRightBit (IRQA, Local0)
                                If (Local0)
                                {
                                    Decrement (Local0)
                                }

                                Store (Local0, CR70)
                            }

                            Store (One, CR30)
                            EXFG ()
                        }

                        Method (_PSC, 0, NotSerialized)
                        {
                            ENFG (0x03)
                            And (CR30, One, Local0)
                            EXFG ()
                            If (Local0)
                            {
                                Return (Zero)
                            }
                            Else
                            {
                                Return (0x03)
                            }
                        }

                        Method (_PS0, 0, NotSerialized)
                        {
                            ENFG (0x03)
                            Store (One, CR30)
                            EXFG ()
                        }

                        Method (_PS3, 0, NotSerialized)
                        {
                            ENFG (0x03)
                            Store (Zero, CR30)
                            EXFG ()
                        }
                    }

                    Mutex (MTIO, 0x00)
                }

                Device (EC)
                {
                    Name (_HID, EisaId ("PNP0C09"))
                    Name (_GPE, 0x18)
                    Name (ECOK, Zero)
                    Method (_REG, 2, NotSerialized)
                    {
                        If (LEqual (Arg0, 0x03))
                        {
                            Store (Arg1, ECOK)
                            Store (Arg1, ^^^ECOK)
                        }
                    }

                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0062,             // Range Minimum
                            0x0062,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0066,             // Range Minimum
                            0x0066,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                    })
                    OperationRegion (ERAM, EmbeddedControl, Zero, 0xFF)
                    Field (ERAM, ByteAcc, NoLock, Preserve)
                    {
                                Offset (0x04), 
                        CMCM,   8, 
                        CMD1,   8, 
                        CMD2,   8, 
                        CMD3,   8
                    }

                    Field (ERAM, ByteAcc, NoLock, Preserve)
                    {
                                Offset (0x80), 
                        NMSG,   8, 
                        SLED,   4, 
                        SLPT,   4, 
                        MODE,   1, 
                        Z000,   1, 
                        ACPI,   1, 
                        PWBN,   1, 
                        TME0,   1, 
                        TME1,   1, 
                        FANC,   1, 
                        DETF,   1, 
                        LIDS,   1, 
                        LWKE,   1, 
                        IWKE,   1, 
                        INTM,   1, 
                        MWKE,   1, 
                        COMM,   1, 
                        PME,    1, 
                                Offset (0x84), 
                        ADP,    1, 
                        AFLT,   1, 
                        BATP,   1, 
                            ,   1, 
                        BATL,   1, 
                        BATC,   1, 
                                Offset (0x85), 
                        BPU,    32, 
                        BDC,    32, 
                        BFC,    32, 
                        BTC,    32, 
                        BDV,    32, 
                        BST,    32, 
                        BPR,    32, 
                        BRC,    32, 
                        BPV,    32, 
                        BTP,    32, 
                        BCW,    32, 
                        BCL,    32, 
                        BCG,    32, 
                        BG2,    32, 
                        BMO,    32, 
                        BIF,    64, 
                        BSN0,   32, 
                        BSN1,   32, 
                        BTY0,   8, 
                        BTY1,   8, 
                        BTY2,   8, 
                        BTY3,   8, 
                        AC0,    16, 
                        PSV,    16, 
                        CRT,    16, 
                        TMP,    16, 
                        NABT,   8, 
                                Offset (0xE4), 
                        BATT,   8, 
                                Offset (0xE9)
                    }

                    Mutex (MTX0, 0x00)
                    Mutex (MTX1, 0x00)
                    Method (_Q0B, 0, NotSerialized)
                    {
                        Notify (SLPB, 0x80)
                    }

                    Method (_Q06, 0, NotSerialized)
                    {
                        Store (0x8C, BCMD)
                        Store (Zero, SMIC)
                        Store ("AC Adapter In/Out", Debug)
                        Store (^^^ADP, Local0)
                        If (ADP)
                        {
                            Notify (AC, Zero)
                            Store (0x88, BCMD)
                            Store (Zero, SMIC)
                        }
                        Else
                        {
                            Notify (AC, One)
                            Store (0x89, BCMD)
                            Store (Zero, SMIC)
                        }
                    }

                    Method (_Q08, 0, NotSerialized)
                    {
                        Store (0x8C, BCMD)
                        Store (Zero, SMIC)
                        Store ("Battery In/Out", Debug)
                        ^^^^BAT0.Z002 ()
                    }

                    Method (_Q09, 0, NotSerialized)
                    {
                        Store ("Battery charge/discharge", Debug)
                        ^^^^BAT0.UBST ()
                        Notify (BAT0, 0x80)
                    }

                    Method (_Q03, 0, NotSerialized)
                    {
                        Store ("Low Batt 1", Debug)
                        Notify (BAT0, 0x80)
                    }

                    Method (_Q04, 0, NotSerialized)
                    {
                        Store ("Low Batt 2", Debug)
                        Notify (BAT0, 0x80)
                    }

                    Method (_Q0A, 0, NotSerialized)
                    {
                        Store ("Lid runtime event", Debug)
                        Notify (LID, 0x80)
                    }

                    Method (_Q07, 0, NotSerialized)
                    {
                        Store ("Thermal status change event", Debug)
                        Notify (\_TZ.THRM, 0x80)
                    }

                    Method (_Q10, 0, NotSerialized)
                    {
                        Store ("_Q10 Enevt", Debug)
                        Store (Zero, Local1)
                        Store (0x94, BCMD)
                        Store (Zero, SMIC)
                        Store (0x54, ^^^AGP.VGA.CMID)
                        Store (^^^AGP.VGA.CMDA, Local1)
                        If (Local1)
                        {
                            If (^^^AGP.VGA.OSF)
                            {
                                Store (^^^AGP.VGA.TOGF, Local0)
                                Store (0x8A, BCMD)
                                Store (Zero, SMIC)
                                Store (0x52, ^^^AGP.VGA.CMID)
                                Store (^^^AGP.VGA.CMDA, Local3)
                                Store (0x53, ^^^AGP.VGA.CMID)
                                Store (^^^AGP.VGA.CMDA, Local4)
                                Store (One, Local5)
                                Store (Zero, Local6)
                                If (Local3)
                                {
                                    Add (Local5, 0x02, Local5)
                                }

                                If (Local4)
                                {
                                    Add (Local5, 0x04, Local5)
                                }

                                If (LGreater (Local0, 0x06))
                                {
                                    Store (Zero, ^^^AGP.VGA.TOGF)
                                    Store (Zero, Local0)
                                }

                                Increment (Local0)
                                And (Local5, Local0, Local6)
                                If (LEqual (Local6, Local0))
                                {
                                    Store (Zero, Local3)
                                }
                                Else
                                {
                                    Store (One, Local3)
                                }

                                While (Local3)
                                {
                                    Increment (Local0)
                                    And (Local5, Local0, Local6)
                                    If (LEqual (Local6, Local0))
                                    {
                                        Store (Zero, Local3)
                                    }
                                    Else
                                    {
                                        Store (One, Local3)
                                    }

                                    If (LGreater (Local0, 0x06))
                                    {
                                        Store (Zero, Local0)
                                    }
                                }

                                Store (Local0, ^^^AGP.VGA.TOGF)
                                If (LEqual (Local6, One))
                                {
                                    Store (One, ^^^AGP.VGA.LCDA)
                                    Store (Zero, ^^^AGP.VGA.CRTA)
                                    Store (Zero, ^^^AGP.VGA.TVOA)
                                }

                                If (LEqual (Local6, 0x02))
                                {
                                    Store (Zero, ^^^AGP.VGA.LCDA)
                                    Store (One, ^^^AGP.VGA.CRTA)
                                    Store (Zero, ^^^AGP.VGA.TVOA)
                                }

                                If (LEqual (Local6, 0x03))
                                {
                                    Store (One, ^^^AGP.VGA.LCDA)
                                    Store (One, ^^^AGP.VGA.CRTA)
                                    Store (Zero, ^^^AGP.VGA.TVOA)
                                }

                                If (LEqual (Local6, 0x04))
                                {
                                    Store (Zero, ^^^AGP.VGA.LCDA)
                                    Store (Zero, ^^^AGP.VGA.CRTA)
                                    Store (One, ^^^AGP.VGA.TVOA)
                                }

                                If (LEqual (Local6, 0x05))
                                {
                                    Store (One, ^^^AGP.VGA.LCDA)
                                    Store (Zero, ^^^AGP.VGA.CRTA)
                                    Store (One, ^^^AGP.VGA.TVOA)
                                }

                                If (LEqual (Local6, 0x06))
                                {
                                    Store (Zero, ^^^AGP.VGA.LCDA)
                                    Store (One, ^^^AGP.VGA.CRTA)
                                    Store (One, ^^^AGP.VGA.TVOA)
                                }

                                If (LEqual (Local6, 0x07))
                                {
                                    Store (One, ^^^AGP.VGA.LCDA)
                                    Store (One, ^^^AGP.VGA.CRTA)
                                    Store (One, ^^^AGP.VGA.TVOA)
                                }

                                If (^^^AGP.VGA.OSF)
                                {
                                    Notify (^^^AGP.VGA, 0x80)
                                }
                                Else
                                {
                                    Store (0x8E, BCMD)
                                    Store (Zero, SMIC)
                                }
                            }
                            Else
                            {
                                Store (0x8E, BCMD)
                                Store (Zero, SMIC)
                                Notify (^^^AGP.VGA, 0x80)
                            }
                        }
                    }
                }
            }

            Device (IDE)
            {
                Name (_ADR, 0x00100000)
                Name (UDMT, Package (0x08)
                {
                    0x1E, 
                    0x2D, 
                    0x3C, 
                    0x5A, 
                    0x78, 
                    0x78, 
                    0x78, 
                    0x14
                })
                Name (PIOT, Package (0x05)
                {
                    0x78, 
                    0xB4, 
                    0xF0, 
                    0x017F, 
                    0x0258
                })
                Name (PIOC, Package (0x05)
                {
                    0x04, 
                    0x06, 
                    0x08, 
                    0x0D, 
                    0x10
                })
                Name (CBCT, Package (0x05)
                {
                    0x31, 
                    0x33, 
                    One, 
                    0x03, 
                    0x0A
                })
                Name (DACT, Package (0x05)
                {
                    0x03, 
                    0x03, 
                    0x04, 
                    0x05, 
                    0x08
                })
                Name (DRCT, Package (0x05)
                {
                    One, 
                    0x03, 
                    0x04, 
                    0x08, 
                    0x08
                })
                Name (PXLM, Package (0x05)
                {
                    0x02, 
                    One, 
                    Zero, 
                    Zero, 
                    Zero
                })
                OperationRegion (PCI, PCI_Config, Zero, 0x60)
                Field (PCI, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x09), 
                        ,   4, 
                    SCHE,   1, 
                    PCHE,   1, 
                            Offset (0x0A), 
                            Offset (0x0D), 
                    IDLT,   8, 
                            Offset (0x4B), 
                    U66E,   1, 
                            Offset (0x4C), 
                            Offset (0x53), 
                    CDFI,   1, 
                    CDUD,   1, 
                            Offset (0x54), 
                    PFTH,   8, 
                    SFTH,   8, 
                    PUDC,   8, 
                    SUDC,   8, 
                    PAST,   8, 
                    PCBT,   8, 
                    PTM0,   8, 
                    PTM1,   8, 
                    SAST,   8, 
                    SCBT,   8, 
                    STM0,   8, 
                    STM1,   8
                }

                Method (GTM, 3, NotSerialized)
                {
                    Store (Buffer (0x14) {}, Local0)
                    CreateDWordField (Local0, Zero, PIO0)
                    CreateDWordField (Local0, 0x04, DMA0)
                    CreateDWordField (Local0, 0x08, PIO1)
                    CreateDWordField (Local0, 0x0C, DMA1)
                    CreateDWordField (Local0, 0x10, FLAG)
                    Store (Zero, PIO0)
                    Store (Zero, DMA0)
                    Store (Zero, PIO1)
                    Store (Zero, DMA1)
                    Store (Zero, FLAG)
                    If (Arg0)
                    {
                        ShiftRight (And (Arg0, 0x70), 0x04, Local1)
                        If (LEqual (Local1, Zero))
                        {
                            Store (0x08, Local1)
                        }

                        Add (And (Arg0, 0x0F, Local2), Local1, Local1)
                        Store (Match (PIOC, MLE, Local1, MTR, Zero, Zero), Local2)
                        Store (DerefOf (Index (PIOT, Local2)), PIO0)
                        If (LLessEqual (PIO0, 0xF0))
                        {
                            Or (FLAG, 0x02, FLAG)
                        }
                    }

                    If (And (Arg2, 0x08))
                    {
                        Store (DerefOf (Index (UDMT, And (Arg2, 0x07))), DMA0)
                        Or (FLAG, One, FLAG)
                    }
                    Else
                    {
                        Store (PIO0, DMA0)
                    }

                    If (Arg1)
                    {
                        ShiftRight (And (Arg1, 0x70), 0x04, Local1)
                        If (LEqual (Local1, Zero))
                        {
                            Store (0x08, Local1)
                        }

                        Add (And (Arg1, 0x0F, Local2), Local1, Local1)
                        Store (Match (PIOC, MLE, Local1, MTR, Zero, Zero), Local2)
                        Store (DerefOf (Index (PIOT, Local2)), PIO1)
                        If (LLessEqual (PIO1, 0xF0))
                        {
                            Or (FLAG, 0x08, FLAG)
                        }
                    }

                    If (And (Arg2, 0x80))
                    {
                        Store (DerefOf (Index (UDMT, ShiftRight (And (Arg2, 0x70), 0x04
                            ))), DMA1)
                        Or (FLAG, 0x04, FLAG)
                    }
                    Else
                    {
                        Store (PIO1, DMA1)
                    }

                    Or (FLAG, 0x10, FLAG)
                    Return (Local0)
                }

                Method (STM, 3, NotSerialized)
                {
                    Store (Buffer (0x06)
                        {
                            0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                        }, Local7)
                    CreateByteField (Local7, Zero, TM0)
                    CreateByteField (Local7, One, TM1)
                    CreateByteField (Local7, 0x02, UDC)
                    CreateByteField (Local7, 0x03, AST)
                    CreateByteField (Local7, 0x04, CBT)
                    CreateByteField (Local7, 0x05, U66)
                    CreateDWordField (Arg0, Zero, PIO0)
                    CreateDWordField (Arg0, 0x04, DMA0)
                    CreateDWordField (Arg0, 0x08, PIO1)
                    CreateDWordField (Arg0, 0x0C, DMA1)
                    CreateDWordField (Arg0, 0x10, FLAG)
                    Store (FLAG, Local6)
                    Store (Ones, Local4)
                    If (LOr (DMA0, PIO0))
                    {
                        If (LAnd (DMA0, LNot (PIO0)))
                        {
                            If (And (Local6, One))
                            {
                                If (LAnd (LLess (DMA0, 0x1E), LGreaterEqual (DMA0, 0x0F)))
                                {
                                    Store (0x07, Local0)
                                }
                                Else
                                {
                                    Store (Match (UDMT, MGE, DMA0, MTR, Zero, Zero), Local0)
                                }

                                Or (Local0, 0x08, UDC)
                                If (LLess (DMA0, 0x3C))
                                {
                                    Store (One, U66)
                                }
                            }

                            Store (Match (PIOT, MGE, DMA0, MTR, Zero, Zero), Local0)
                            Store (DerefOf (Index (DACT, Local0)), Local2)
                            Store (DerefOf (Index (DRCT, Local0)), Local3)
                            Add (Local3, ShiftLeft (Local2, 0x04), TM0)
                            Store (Local0, Local4)
                        }

                        If (LAnd (LNot (DMA0), PIO0))
                        {
                            Store (Match (PIOT, MGE, PIO0, MTR, Zero, Zero), Local0)
                            Store (DerefOf (Index (DACT, Local0)), Local2)
                            Store (DerefOf (Index (DRCT, Local0)), Local3)
                            Add (Local3, ShiftLeft (Local2, 0x04), TM0)
                            Store (Local0, Local4)
                        }

                        If (LAnd (DMA0, PIO0))
                        {
                            If (And (Local6, One))
                            {
                                If (LAnd (LLess (DMA0, 0x1E), LGreaterEqual (DMA0, 0x0F)))
                                {
                                    Store (0x07, Local0)
                                }
                                Else
                                {
                                    Store (Match (UDMT, MGE, DMA0, MTR, Zero, Zero), Local0)
                                }

                                Or (Local0, 0x08, UDC)
                                If (LLess (DMA0, 0x3C))
                                {
                                    Store (One, U66)
                                }
                            }

                            If (LGreaterEqual (PIO0, DMA0))
                            {
                                Store (Match (PIOT, MGE, PIO0, MTR, Zero, Zero), Local0)
                                Store (Local0, Local4)
                            }
                            Else
                            {
                                Store (Match (PIOT, MGE, DMA0, MTR, Zero, Zero), Local0)
                                Store (Local0, Local4)
                            }

                            Store (DerefOf (Index (DACT, Local0)), Local2)
                            Store (DerefOf (Index (DRCT, Local0)), Local3)
                            Add (Local3, ShiftLeft (Local2, 0x04), TM0)
                        }
                    }

                    Store (Ones, Local5)
                    If (LOr (DMA1, PIO1))
                    {
                        If (LAnd (DMA1, LNot (PIO1)))
                        {
                            If (And (Local6, 0x04))
                            {
                                If (LAnd (LLess (DMA1, 0x1E), LGreaterEqual (DMA1, 0x0F)))
                                {
                                    Store (0x07, Local0)
                                }
                                Else
                                {
                                    Store (Match (UDMT, MGE, DMA1, MTR, Zero, Zero), Local0)
                                }

                                Or (ShiftLeft (Or (Local0, 0x08), 0x04), UDC, UDC)
                                If (LLess (DMA1, 0x3C))
                                {
                                    Store (One, U66)
                                }
                            }

                            Store (Match (PIOT, MGE, DMA1, MTR, Zero, Zero), Local0)
                            Store (DerefOf (Index (DACT, Local0)), Local2)
                            Store (DerefOf (Index (DRCT, Local0)), Local3)
                            Add (Local3, ShiftLeft (Local2, 0x04), TM1)
                            Store (Local0, Local5)
                        }

                        If (LAnd (LNot (DMA1), PIO1))
                        {
                            Store (Match (PIOT, MGE, PIO1, MTR, Zero, Zero), Local0)
                            Store (DerefOf (Index (DACT, Local0)), Local2)
                            Store (DerefOf (Index (DRCT, Local0)), Local3)
                            Add (Local3, ShiftLeft (Local2, 0x04), TM1)
                            Store (Local0, Local5)
                        }

                        If (LAnd (DMA1, PIO1))
                        {
                            If (And (Local6, 0x04))
                            {
                                If (LAnd (LLess (DMA1, 0x1E), LGreaterEqual (DMA1, 0x0F)))
                                {
                                    Store (0x07, Local0)
                                }
                                Else
                                {
                                    Store (Match (UDMT, MGE, DMA1, MTR, Zero, Zero), Local0)
                                }

                                Or (ShiftLeft (Or (Local0, 0x08), 0x04), UDC, UDC)
                                If (LLess (DMA1, 0x3C))
                                {
                                    Store (One, U66)
                                }
                            }

                            If (LGreaterEqual (PIO1, DMA1))
                            {
                                Store (Match (PIOT, MGE, PIO1, MTR, Zero, Zero), Local0)
                                Store (Local0, Local5)
                            }
                            Else
                            {
                                Store (Match (PIOT, MGE, DMA1, MTR, Zero, Zero), Local0)
                                Store (Local0, Local5)
                            }

                            Store (DerefOf (Index (DACT, Local0)), Local2)
                            Store (DerefOf (Index (DRCT, Local0)), Local3)
                            Add (Local3, ShiftLeft (Local2, 0x04), TM1)
                        }
                    }

                    If (LEqual (Local4, Ones))
                    {
                        If (LEqual (Local5, Ones))
                        {
                            Store (Zero, CBT)
                        }
                        Else
                        {
                            Store (DerefOf (Index (CBCT, Local5)), CBT)
                        }
                    }
                    Else
                    {
                        If (LEqual (Local5, Ones))
                        {
                            Store (DerefOf (Index (CBCT, Local4)), CBT)
                        }
                        Else
                        {
                            If (LGreaterEqual (Local4, Local5))
                            {
                                Store (DerefOf (Index (CBCT, Local4)), CBT)
                            }
                            Else
                            {
                                Store (DerefOf (Index (CBCT, Local5)), CBT)
                            }
                        }
                    }

                    Store (0x02, AST)
                    Return (Local7)
                }

                Method (GTF0, 3, NotSerialized)
                {
                    Store (Buffer (0x07)
                        {
                            0x03, 0x00, 0x00, 0x00, 0x00, 0xA0, 0xEF
                        }, Local7)
                    CreateByteField (Local7, One, MODE)
                    If (And (Arg1, 0x08))
                    {
                        And (Arg1, 0x07, Local0)
                        If (LEqual (Local0, 0x07))
                        {
                            Store (0x05, MODE)
                        }
                        Else
                        {
                            Subtract (0x04, Local0, MODE)
                        }

                        Or (MODE, 0x40, MODE)
                    }
                    Else
                    {
                        And (Arg2, 0x0F, Local0)
                        Store (Match (DRCT, MEQ, Local0, MTR, Zero, Zero), Local1)
                        Store (DerefOf (Index (PXLM, Local1)), MODE)
                        Or (MODE, 0x20, MODE)
                    }

                    Concatenate (Local7, Local7, Local6)
                    And (Arg2, 0x0F, Local0)
                    Store (Match (DRCT, MEQ, Local0, MTR, Zero, Zero), Local1)
                    Subtract (0x04, Local1, MODE)
                    Or (MODE, 0x08, MODE)
                    Concatenate (Local6, Local7, Local5)
                    Return (Local5)
                }

                Method (GTF1, 3, NotSerialized)
                {
                    Store (Buffer (0x07)
                        {
                            0x03, 0x00, 0x00, 0x00, 0x00, 0xB0, 0xEF
                        }, Local7)
                    CreateByteField (Local7, One, MODE)
                    If (And (Arg1, 0x80))
                    {
                        ShiftRight (And (Arg1, 0x70), 0x04, Local0)
                        If (LEqual (Local0, 0x07))
                        {
                            Store (0x05, MODE)
                        }
                        Else
                        {
                            Subtract (0x04, Local0, MODE)
                        }

                        Or (MODE, 0x40, MODE)
                    }
                    Else
                    {
                        And (Arg2, 0x0F, Local0)
                        Store (Match (DRCT, MEQ, Local0, MTR, Zero, Zero), Local1)
                        Store (DerefOf (Index (PXLM, Local1)), MODE)
                        Or (MODE, 0x20, MODE)
                    }

                    Concatenate (Local7, Local7, Local6)
                    And (Arg2, 0x0F, Local0)
                    Store (Match (DRCT, MEQ, Local0, MTR, Zero, Zero), Local1)
                    Subtract (0x04, Local1, MODE)
                    Or (MODE, 0x08, MODE)
                    Concatenate (Local6, Local7, Local5)
                    Return (Local5)
                }

                Device (PRIM)
                {
                    Name (_ADR, Zero)
                    Method (_GTM, 0, NotSerialized)
                    {
                        Store ("GTM - Primary Controller", Debug)
                        Store (GTM (PTM0, PTM1, PUDC), Local0)
                        Return (Local0)
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store ("STM - Primary Controller", Debug)
                        Store (STM (Arg0, Arg1, Arg2), Local0)
                        CreateByteField (Local0, Zero, TM0)
                        CreateByteField (Local0, One, TM1)
                        CreateByteField (Local0, 0x02, UDC)
                        CreateByteField (Local0, 0x03, AST)
                        CreateByteField (Local0, 0x04, CBT)
                        CreateByteField (Local0, 0x05, U66)
                        Store (TM0, PTM0)
                        Store (TM1, PTM1)
                        Store (UDC, PUDC)
                        Store (AST, PAST)
                        Store (CBT, PCBT)
                        If (U66)
                        {
                            Store (U66, U66E)
                        }

                        Store (0x55, PFTH)
                    }

                    Device (MAST)
                    {
                        Name (_ADR, Zero)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Store ("GTF - Primary Master", Debug)
                            Store (GTF0 (PCHE, PUDC, PTM0), Local0)
                            Return (Local0)
                        }
                    }

                    Device (SLAV)
                    {
                        Name (_ADR, One)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Store ("GTF - Primary Slave", Debug)
                            Store (GTF1 (PCHE, PUDC, PTM1), Local0)
                            Return (Local0)
                        }
                    }
                }

                Device (SECN)
                {
                    Name (_ADR, One)
                    Method (_GTM, 0, NotSerialized)
                    {
                        Store ("GTM - Secondary Controller", Debug)
                        Store (GTM (STM0, STM1, SUDC), Local0)
                        Return (Local0)
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store ("STM - Secondary Controller", Debug)
                        Store (STM (Arg0, Arg1, Arg2), Local0)
                        CreateByteField (Local0, Zero, TM0)
                        CreateByteField (Local0, One, TM1)
                        CreateByteField (Local0, 0x02, UDC)
                        CreateByteField (Local0, 0x03, AST)
                        CreateByteField (Local0, 0x04, CBT)
                        CreateByteField (Local0, 0x05, U66)
                        Store (TM0, STM0)
                        Store (TM1, STM1)
                        Store (UDC, SUDC)
                        Store (AST, SAST)
                        Store (CBT, SCBT)
                        If (U66)
                        {
                            Store (U66, U66E)
                        }

                        Store (0x55, SFTH)
                    }

                    Device (MAST)
                    {
                        Name (_ADR, Zero)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Store ("GTF - Secondary Master", Debug)
                            Store (GTF0 (SCHE, SUDC, STM0), Local0)
                            Return (Local0)
                        }
                    }

                    Device (SLAV)
                    {
                        Name (_ADR, One)
                        Method (_STA, 0, NotSerialized)
                        {
                            Return (Zero)
                        }

                        Method (_GTF, 0, NotSerialized)
                        {
                            Store ("GTF - Secondary Slave", Debug)
                            Store (GTF1 (SCHE, SUDC, STM1), Local0)
                            Return (Local0)
                        }
                    }
                }
            }

            Device (AGP)
            {
                Name (_ADR, 0x00010000)
                Name (_PRT, Package (0x01)
                {
                    Package (0x04)
                    {
                        0x0005FFFF, 
                        Zero, 
                        ^ISA.LNK2, 
                        Zero
                    }
                })
                Device (VGA)
                {
                    Name (_ADR, 0x00050000)
                    Name (SWIT, One)
                    Name (CRTA, One)
                    Name (LCDA, One)
                    Name (TVOA, One)
                    Name (TOGF, One)
                    Name (OSF, Zero)
                    OperationRegion (CMOS, SystemIO, 0x70, 0x02)
                    Field (CMOS, ByteAcc, NoLock, Preserve)
                    {
                        CMID,   8, 
                        CMDA,   8
                    }

                    Method (_INI, 0, NotSerialized)
                    {
                        If (LEqual (SCMP (_OS, "Microsoft Windows NT"), Zero))
                        {
                            Store (One, OSF)
                        }

                        If (LEqual (SizeOf (_OS), 0x14))
                        {
                            Store (One, OSF)
                        }
                    }

                    Method (_DOS, 1, NotSerialized)
                    {
                        Store ("VGA --_DOS", Debug)
                        Store (Arg0, SWIT)
                    }

                    Method (_DOD, 0, NotSerialized)
                    {
                        Store ("VGA --_DOD", Debug)
                        Return (Package (0x03)
                        {
                            0x00010100, 
                            0x00010110, 
                            0x00010200
                        })
                    }

                    Device (CRT)
                    {
                        Name (_ADR, 0x0100)
                        Method (_DCS, 0, NotSerialized)
                        {
                            Store ("CRT --_DCS", Debug)
                            If (CRTA)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            Store ("CRT --_DGS", Debug)
                            Store (CRTA, Local0)
                            If (CRTA)
                            {
                                Return (One)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            Store ("CRT --_DSS", Debug)
                        }
                    }

                    Device (LCD)
                    {
                        Name (_ADR, 0x0110)
                        Method (_DCS, 0, NotSerialized)
                        {
                            Store ("LCD --_DCS", Debug)
                            If (LCDA)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            Store ("LCD --_DGS", Debug)
                            Store (LCDA, Local0)
                            If (LCDA)
                            {
                                Return (One)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            Store ("LCD --_DSS", Debug)
                        }
                    }

                    Device (TVO)
                    {
                        Name (_ADR, 0x0200)
                        Method (_DCS, 0, NotSerialized)
                        {
                            Store ("TVO --_DCS", Debug)
                            If (TVOA)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            Store ("TVO --_DGS", Debug)
                            Store (TVOA, Local0)
                            If (TVOA)
                            {
                                Return (One)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            Store ("TVO --_DSS", Debug)
                        }
                    }
                }
            }

            Method (MIN, 2, NotSerialized)
            {
                If (LLess (Arg0, Arg1))
                {
                    Return (Arg0)
                }
                Else
                {
                    Return (Arg1)
                }
            }

            Method (SLEN, 1, NotSerialized)
            {
                Return (SizeOf (Arg0))
            }

            Method (S2BF, 1, Serialized)
            {
                Add (SLEN (Arg0), One, Local0)
                Name (BUFF, Buffer (Local0) {})
                Store (Arg0, BUFF)
                Return (BUFF)
            }

            Method (SCMP, 2, NotSerialized)
            {
                Store (S2BF (Arg0), Local0)
                Store (S2BF (Arg1), Local1)
                Store (Zero, Local4)
                Store (SLEN (Arg0), Local5)
                Store (SLEN (Arg1), Local6)
                Store (MIN (Local5, Local6), Local7)
                While (LLess (Local4, Local7))
                {
                    Store (DerefOf (Index (Local0, Local4)), Local2)
                    Store (DerefOf (Index (Local1, Local4)), Local3)
                    If (LGreater (Local2, Local3))
                    {
                        Return (One)
                    }
                    Else
                    {
                        If (LLess (Local2, Local3))
                        {
                            Return (Ones)
                        }
                    }

                    Increment (Local4)
                }

                If (LLess (Local4, Local5))
                {
                    Return (One)
                }
                Else
                {
                    If (LLess (Local4, Local6))
                    {
                        Return (Ones)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }
            }

            Device (CRD0)
            {
                Name (_ADR, 0x000A0000)
                Name (_PRW, Package (0x02)
                {
                    0x09, 
                    Zero
                })
                Method (_INI, 0, NotSerialized)
                {
                    Or (PMEE, One, PMEE)
                    Store (One, PMEN)
                }

                Method (_PSC, 0, NotSerialized)
                {
                    Store (PWST, Local0)
                    Return (Local0)
                }

                Method (_PS0, 0, NotSerialized)
                {
                    Store (One, PMST)
                }

                Method (_PS2, 0, NotSerialized)
                {
                    Store (One, PMST)
                }

                Method (_PS3, 0, NotSerialized)
                {
                    Store (One, PMST)
                }

                Name (EX03, Zero)
                Method (_PSW, 1, NotSerialized)
                {
                    If (LEqual (Arg0, One))
                    {
                        Store (Zero, PWST)
                        Or (PMEE, One, PMEE)
                        Store (TI04, Local1)
                        Store (Or (TI04, One), TI04)
                        Store (0x03E1, TI44)
                        Store (0x03, TIID)
                        Store (TIDA, EX03)
                        Store (Or (EX03, 0x80), TIDA)
                    }
                    Else
                    {
                        Store (Zero, PWST)
                        If (LEqual (PMST, One))
                        {
                            Store (One, PMST)
                            Notify (CRD0, Zero)
                        }
                    }
                }

                OperationRegion (CCRD, PCI_Config, Zero, 0xA7)
                Field (CCRD, ByteAcc, Lock, Preserve)
                {
                            Offset (0x04), 
                    TI04,   8, 
                            Offset (0x44), 
                    TI44,   16, 
                            Offset (0x80), 
                    PMEE,   1, 
                            Offset (0x81), 
                            Offset (0xA4), 
                    PWST,   2, 
                            Offset (0xA5), 
                    PMEN,   1, 
                        ,   6, 
                    PMST,   1
                }

                OperationRegion (TIIO, SystemIO, 0x03E0, 0x02)
                Field (TIIO, ByteAcc, NoLock, Preserve)
                {
                    TIID,   8, 
                    TIDA,   8
                }
            }

            Device (PM)
            {
                Name (_ADR, 0x00110000)
                OperationRegion (PMUD, PCI_Config, Zero, 0xC0)
                Field (PMUD, DWordAcc, Lock, Preserve)
                {
                            Offset (0x98), 
                        ,   4, 
                    KBCS,   2, 
                            Offset (0xB5), 
                    IDBA,   3, 
                            Offset (0xB6), 
                        ,   5, 
                    GP29,   1, 
                        ,   6, 
                    BAYR,   1, 
                        ,   1, 
                    R09D,   1, 
                    R09F,   1
                }
            }

            Device (NICD)
            {
                Name (_ADR, 0x000B0000)
                Name (_PRW, Package (0x02)
                {
                    0x09, 
                    0x03
                })
            }

            Device (USB0)
            {
                Name (_ADR, 0x00130000)
                Name (_PRW, Package (0x02)
                {
                    0x09, 
                    0x03
                })
                Name (_S3D, 0x03)
            }

            Device (USB1)
            {
                Name (_ADR, 0x00130001)
                Name (_PRW, Package (0x02)
                {
                    0x09, 
                    0x03
                })
                Name (_S3D, 0x03)
            }

            Device (USB2)
            {
                Name (_ADR, 0x00130002)
                Name (_PRW, Package (0x02)
                {
                    0x09, 
                    0x03
                })
                Name (_S3D, 0x03)
            }

            Device (MODM)
            {
                Name (_ADR, 0x00080000)
                Name (_PRW, Package (0x02)
                {
                    0x09, 
                    0x03
                })
            }
        }

        Device (AC)
        {
            Name (_HID, "ACPI0003")
            Name (_PCL, Package (0x01)
            {
                _SB
            })
            Name (ACP, Zero)
            Method (_STA, 0, NotSerialized)
            {
                Store ("---------------------------- AC _STA", Debug)
                Return (0x0F)
            }

            Method (_PSR, 0, NotSerialized)
            {
                Store ("---------------------------- AC _PSR", Debug)
                Store (ACP, Local0)
                Store (0x8C, ^^PCI0.ISA.BCMD)
                Store (Zero, ^^PCI0.ISA.SMIC)
                Store (^^PCI0.ADP, Local0)
                If (LNotEqual (Local0, ACP))
                {
                    FLPA ()
                }

                If (Local0)
                {
                    Store ("---------------------------- AC on line", Debug)
                }
                Else
                {
                    Store ("---------------------------- AC off line", Debug)
                }

                Return (Local0)
            }

            Method (CHAC, 0, NotSerialized)
            {
                Store ("---------------------------- AC _CHAC", Debug)
                If (^^PCI0.ISA.EC.ECOK)
                {
                    Acquire (^^PCI0.ISA.EC.MTX0, 0xFFFF)
                    Store (^^PCI0.ISA.EC.ADP, Local0)
                    Release (^^PCI0.ISA.EC.MTX0)
                    If (LNotEqual (Local0, ACP))
                    {
                        FLPA ()
                    }
                }
            }

            Method (FLPA, 0, NotSerialized)
            {
                Store ("---------------------------- AC _FLPA", Debug)
                If (ACP)
                {
                    Store (Zero, ACP)
                }
                Else
                {
                    Store (One, ACP)
                }

                Notify (AC, Zero)
            }
        }

        Device (BAT0)
        {
            Name (_HID, EisaId ("PNP0C0A"))
            Name (_UID, One)
            Name (_PCL, Package (0x01)
            {
                _SB
            })
            Name (BIFB, Package (0x0D)
            {
                One, 
                0x0514, 
                0x0514, 
                One, 
                0x2A30, 
                0x0138, 
                0x9C, 
                0x0D, 
                0x0D, 
                "CA54200", 
                "1", 
                "", 
                "Dynapack"
            })
            Name (BSTB, Package (0x04)
            {
                Zero, 
                Ones, 
                Ones, 
                0x2710
            })
            Name (MDLS, Package (0x07)
            {
                "Unknown", 
                " 3500", 
                " 3800", 
                " 4500", 
                " 2600", 
                " 3000", 
                " 3200"
            })
            Name (CHAR, Package (0x10)
            {
                "0", 
                "1", 
                "2", 
                "3", 
                "4", 
                "5", 
                "6", 
                "7", 
                "8", 
                "9", 
                "A", 
                "B", 
                "C", 
                "D", 
                "E", 
                "F"
            })
            Method (PBFE, 3, NotSerialized)
            {
                CreateByteField (Arg0, Arg1, TIDX)
                Store (Arg2, TIDX)
            }

            Method (ITOS, 1, NotSerialized)
            {
                Store ("", Local0)
                Store (0x08, Local1)
                While (Local1)
                {
                    Decrement (Local1)
                    And (ShiftRight (Arg0, ShiftLeft (Local1, 0x02)), 0x0F, Local4)
                    Store (DerefOf (Index (CHAR, Local4)), Local2)
                    Concatenate (Local0, Local2, Local5)
                    Store (Local5, Local0)
                }

                Return (Local0)
            }

            Method (Z003, 1, NotSerialized)
            {
                Store ("", Local0)
                Store (0x04, Local1)
                While (Local1)
                {
                    Decrement (Local1)
                    And (ShiftRight (Arg0, ShiftLeft (Local1, 0x02)), 0x0F, Local4)
                    Store (DerefOf (Index (CHAR, Local4)), Local2)
                    Concatenate (Local0, Local2, Local5)
                    Store (Local5, Local0)
                }

                Return (Local0)
            }

            Method (_STA, 0, NotSerialized)
            {
                Store (0x8B, ^^PCI0.ISA.BCMD)
                Store (Zero, ^^PCI0.ISA.SMIC)
                Store (^^PCI0.BATP, Local0)
                If (Or (Local0, Local0))
                {
                    Return (0x1F)
                }
                Else
                {
                    Return (0x0F)
                }
            }

            Method (_BIF, 0, NotSerialized)
            {
                Store (0x8B, ^^PCI0.ISA.BCMD)
                Store (Zero, ^^PCI0.ISA.SMIC)
                Acquire (^^PCI0.ISA.EC.MTX0, 0xFFFF)
                Store (Zero, Index (BIFB, Zero))
                Store (^^PCI0.BDV, Local1)
                Store (^^PCI0.BDC, Local0)
                Multiply (Local0, Local1, Local0)
                Divide (Local0, 0x03E8, Local2, Local0)
                Store (Local0, Index (BIFB, One))
                Store (^^PCI0.BFC, Local0)
                Multiply (Local0, Local1, Local0)
                Divide (Local0, 0x03E8, Local2, Local0)
                Store (Local0, Index (BIFB, 0x02))
                Store (^^PCI0.BTC, Index (BIFB, 0x03))
                Store (^^PCI0.BDV, Index (BIFB, 0x04))
                Store (^^PCI0.BCW, Local0)
                Multiply (Local0, Local1, Local0)
                Divide (Local0, 0x03E8, Local2, Local0)
                Store (Local0, Index (BIFB, 0x05))
                Store (^^PCI0.BCL, Local0)
                Multiply (Local0, Local1, Local0)
                Divide (Local0, 0x03E8, Local2, Local0)
                Store (Local0, Index (BIFB, 0x06))
                Store (^^PCI0.BCG, Local0)
                Multiply (Local0, Local1, Local0)
                Divide (Local0, 0x03E8, Local2, Local0)
                Store (Local0, Index (BIFB, 0x07))
                Store (^^PCI0.BG2, Local0)
                Multiply (Local0, Local1, Local0)
                Divide (Local0, 0x03E8, Local2, Local0)
                Store (Local0, Index (BIFB, 0x08))
                Store (^^PCI0.BMO, Local5)
                Store (^^PCI0.NABT, Local5)
                And (Local5, 0x0F, Local5)
                If (LGreater (Local5, 0x06))
                {
                    Store (DerefOf (Index (MDLS, Zero)), Index (BIFB, 0x09))
                }
                Else
                {
                    Store ("---------------- NABT < 6 ", Debug)
                    Store (^^PCI0.NABT, Local5)
                    And (Local5, 0x0F, Local5)
                    Store (Zero, Local1)
                    If (LEqual (Local5, One))
                    {
                        Store (One, Local1)
                    }

                    If (LEqual (Local5, 0x04))
                    {
                        Store (One, Local1)
                    }

                    Store (^^PCI0.BDC, Local0)
                    If (LEqual (Local1, One))
                    {
                        Store ("---------------------NiMH battery, NABT =1,4 ", Debug)
                        If (LGreaterEqual (Local0, 0x0ED8))
                        {
                            Store (Z003 (ToBCD (Local0)), Local1)
                            Store (Local1, Index (BIFB, 0x09))
                            Store ("-------------------- DC > 3800 ", Debug)
                        }
                        Else
                        {
                            Store ("3800", Index (BIFB, 0x09))
                            Store ("-------------------- DC <= 3800 ", Debug)
                        }

                        Store (^^PCI0.BDC, Local0)
                        If (LEqual (Local0, 0x11C6))
                        {
                            Store ("3800", Index (BIFB, 0x09))
                            Store ("-------------------- DC =4550 ", Debug)
                        }
                    }
                    Else
                    {
                        Store ("---------------- Li Battery ", Debug)
                        If (LGreaterEqual (Local0, 0x0BB8))
                        {
                            Store (Z003 (ToBCD (Local0)), Local1)
                            Store (Local1, Index (BIFB, 0x09))
                            Store ("--------------------- DC >= 3000 ", Debug)
                        }
                        Else
                        {
                            Store ("2600", Index (BIFB, 0x09))
                            Store ("--------------------- DC < 3000 ", Debug)
                        }
                    }
                }

                If (LGreaterEqual (Local0, 0x1388))
                {
                    Store ("A52066L                                                                                     ", Index (BIFB, 0x0A))
                }
                Else
                {
                    Store ("A52044L                                                                                     ", Index (BIFB, 0x0A))
                }

                Store (^^PCI0.BSN0, Local0)
                Store (^^PCI0.BSN1, Local1)
                Store (^^PCI0.BTY0, Local0)
                Store (^^PCI0.BTY1, Local1)
                Store (^^PCI0.BTY2, Local2)
                Store (^^PCI0.BTY3, Local3)
                Store (Buffer (0x05) {}, Local4)
                PBFE (Local4, Zero, Local0)
                PBFE (Local4, One, Local1)
                PBFE (Local4, 0x02, Local2)
                PBFE (Local4, 0x03, Local3)
                PBFE (Local4, 0x04, Zero)
                Name (Z004, "xxxxxxxx")
                Store (Local4, Z004)
                Store (Z004, Index (BIFB, 0x0B))
                If (^^PCI0.BATP)
                {
                    If (LEqual (^^PCI0.ISA.EC.BATT, One))
                    {
                        Store ("Dynapack", Index (BIFB, 0x0C))
                    }
                    Else
                    {
                        If (LEqual (^^PCI0.ISA.EC.BATT, 0x02))
                        {
                            Store ("GLW", Index (BIFB, 0x0C))
                        }
                        Else
                        {
                            If (LEqual (^^PCI0.ISA.EC.BATT, 0x03))
                            {
                                Store ("Simplo", Index (BIFB, 0x0C))
                            }
                            Else
                            {
                                Store ("Unidentify", Index (BIFB, 0x0C))
                            }
                        }
                    }
                }
                Else
                {
                    Store (" ", Index (BIFB, 0x0C))
                }

                Release (^^PCI0.ISA.EC.MTX0)
                Return (BIFB)
            }

            Method (_BST, 0, NotSerialized)
            {
                UBST ()
                Return (BSTB)
            }

            Name (CRIT, Zero)
            Method (UBST, 0, NotSerialized)
            {
                Store (0x8C, ^^PCI0.ISA.BCMD)
                Store (Zero, ^^PCI0.ISA.SMIC)
                Store (^^PCI0.BST, Index (BSTB, Zero))
                Store (^^PCI0.BPR, Local0)
                Store (^^PCI0.BDV, Local1)
                If (LGreaterEqual (Local0, 0x8000))
                {
                    Subtract (0x00010000, Local0, Local0)
                    Multiply (Local0, Local1, Local0)
                    Divide (Local0, 0x03E8, Local2, Local0)
                    Store (Local0, Index (BSTB, One))
                }
                Else
                {
                    Multiply (Local0, Local1, Local0)
                    Divide (Local0, 0x03E8, Local2, Local0)
                    Store (Local0, Index (BSTB, One))
                }

                Store (^^PCI0.BRC, Local0)
                Multiply (Local0, Local1, Local0)
                Divide (Local0, 0x03E8, Local2, Local0)
                Store (Local0, Index (BSTB, 0x02))
                Store (^^PCI0.BPV, Index (BSTB, 0x03))
                Store (DerefOf (Index (BSTB, Zero)), Local0)
                If (^^PCI0.ISA.EC.ECOK)
                {
                    Store (^^PCI0.ISA.EC.BATC, Local1)
                }

                And (Local0, 0xFFFB, Local0)
                ShiftLeft (Local1, 0x02, Local1)
                Add (Local0, Local1, Local0)
                Store (Local0, Index (BSTB, Zero))
            }

            Method (Z002, 0, NotSerialized)
            {
                Acquire (^^PCI0.ISA.EC.MTX1, 0xFFFF)
                If (LEqual (_STA (), 0x1F))
                {
                    UBST ()
                    _BIF ()
                    Notify (AC, Zero)
                    Notify (BAT0, Zero)
                    Notify (BAT0, 0x80)
                    Notify (BAT0, 0x81)
                }
                Else
                {
                    UBST ()
                    Notify (AC, Zero)
                    Notify (BAT0, Zero)
                    Notify (BAT0, 0x80)
                    Notify (BAT0, 0x81)
                }

                ^^AC.FLPA ()
                Release (^^PCI0.ISA.EC.MTX1)
            }
        }
    }

    Name (TPL, 0x0CFA)
    Scope (_TZ)
    {
        ThermalZone (THRM)
        {
            Name (Z005, Zero)
            Method (_TMP, 0, NotSerialized)
            {
                Store (0x8D, \_SB.PCI0.ISA.BCMD)
                Store (Zero, \_SB.PCI0.ISA.SMIC)
                Store (" ----------------- THRM_TMP -----------------", Debug)
                If (\_SB.PCI0.ISA.EC.ECOK)
                {
                    If (\_SB.PCI0.BATC)
                    {
                        Notify (\_SB.BAT0, 0x80)
                    }

                    Acquire (\_SB.PCI0.ISA.EC.MTX0, 0xFFFF)
                    Store (\_SB.PCI0.TMP, Local0)
                    Release (\_SB.PCI0.ISA.EC.MTX0)
                    Multiply (Local0, 0x0A, Local1)
                    Add (Local1, 0x0AAC, Local0)
                    If (LGreater (Local0, 0x0AAC))
                    {
                        Return (Local0)
                    }
                    Else
                    {
                        Return (TPL)
                    }
                }
                Else
                {
                    Return (TPL)
                }
            }

            Name (_PSL, Package (0x01)
            {
                \_PR.CPU0
            })
            Name (_PSV, 0x0E80)
            Name (_CRT, 0x0E94)
            Name (_TC1, Zero)
            Name (_TC2, One)
            Name (_TSP, 0x96)
            Method (_SCP, 1, NotSerialized)
            {
                Store (Arg0, Z005)
            }
        }
    }

    Scope (_GPE)
    {
    }
}

