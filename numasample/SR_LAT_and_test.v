// SR_LAT_and_test.v : SR-Latch �ƃe�X�g�x���`�̗�
//
//	�{���́C�_�������ΏۂƂȂ��H�����iSR_LAT�j�ƃe�X�g�x���`�iSR_LAT_TEST�j�Ƃ́C
//	�t�@�C���𕪗����ׂ������C�킩��₷���̂��߁C�����Ă܂Ƃ߂Ă���B

//	�擪�ɂ����Ă���K�v����imodule �L�q�̑O�j
`timescale 1 ns / 1 ns	// �V�~�����[�V���������̒P�� / ���x���Ƃ��� 1 ns �Ƃ���

//--------------	SR-Latch�iassign ���j	  --------------

module SR_LAT (nS, nR, Q, nQ);
  input nS, nR;
  output Q, nQ;
  assign #1  Q = !(nS & nQ);
  assign #1 nQ = !(nR &  Q);
endmodule

//--------------	SR-Latch�igate �ڑ��j	  --------------

module SR_LAT_GATE (nS, nR, Q, nQ);
  input nS, nR;
  output Q, nQ;
  nand #1 N3 ( Q, nS, nQ);
  nand #1 N4 (nQ, nR,  Q);
endmodule

//--------------	SR-Latch �p�̃e�X�g�x���`	  --------------

module SR_LAT_TEST;
  parameter CYCLE = 5;
  wire Q, nQ, QG, nQG;
  reg nS, nR;

  initial
  begin
    $dumpfile("SR_LAT_and_test.vcd");	// VCD�iValue Change Dump�j�t�@�C���̖��O���w��
    $dumpvars(0);			// VCD �f�[�^�̏o�͑ΏہF���ׂĂɐݒ�
    $monitor("%4t nS:%b nR:%b Q:%b nQ:%b QG:%b nQG:%b",$time, nS, nR, Q, nQ, QG, nQG);	// ���ʂ��Q�Ƃ���M�����ƕ\���`���̎w��icf. printf()�j
    #0		// ���� 0 ns �ł̏������i#0 �͖����Ă��ǂ��j
      nS = 1; nR = 1;
    #CYCLE	// 1 * CYCLE ns�i# �̌�ɒx�����ԁj
      nR = 0;		// Q = 0 �Ƀ��Z�b�g
    #CYCLE	// 2 * CYCLE ns
      nR = 1;
    #CYCLE	// 3 * CYCLE ns
      nS = 0;		// Q = 1 �ɃZ�b�g
    #CYCLE	// 4 * CYCLE ns
      nS = 1;
    #CYCLE	// 5 * CYCLE ns
      nS = 0;  nR = 0;	// �����ċ֎~���� nS = nR = 0 ��^���Ă݂�
    #CYCLE	// 6 * CYCLE ns
      nS = 1;		// nS ����ɖ����ɂȂ� �� Q = 0 �Ƀ��Z�b�g
    #1
      nR = 1;
    #(CYCLE-1)	// 7 * CYCLE ns
      nS = 0;  nR = 0;	// �ēx�C�֎~���� nS = nR = 0 ��^���Ă݂�
    #CYCLE	// 8 * CYCLE ns
      nS = 1;  nR = 1;	// ���x�́C������ nS = nR = 1 �Ɩ����������..
    #(CYCLE*3)	// 11 * CYCLE ns
    $finish;	// �V�~�����[�V�����I��
  end

//	SR_LAT, SR_LAT_GATE ���C���X�^���X���i���ʃ��W���[���ďo���j
  SR_LAT      SR  (nS, nR, Q,  nQ );	// SR-Latch
  SR_LAT_GATE SRG (nS, nR, QG, nQG);	// SR-Latch�iGate �ڑ��j
endmodule

/*--------------------------------------------------------------------*

ivgo.bat ���s�ɂ��V�~�����[�V�������ʂ̗�i"//" �ȍ~�͒��߁j

//	iverilog �ɂ��R���p�C���F-o �ɑ����ďo�̓t�@�C�������w��i�ȗ����� a.out �ɏo�́j�C
//	���̌�ɕK�v�� Verilog-HDL �\�[�X�̃t�@�C��������ׂ�
C:\iverilog\v>iverilog SR_LAT_and_test.v

//	�������ꂽ a.out �� vvp �R�}���h�ɓn���āC�V�~�����[�V�������s
C:\iverilog\v>vvp a.out
VCD info: dumpfile test.vcd opened for output.
  0 nS:1 nR:1 Q:x nQ:x QG:x nQG:x
  5 nS:1 nR:0 Q:x nQ:x QG:x nQG:x
  6 nS:1 nR:0 Q:x nQ:1 QG:x nQG:1
  7 nS:1 nR:0 Q:0 nQ:1 QG:0 nQG:1	nR = 0 -> Q = QG = 0 �Ƀ��Z�b�g
 10 nS:1 nR:1 Q:0 nQ:1 QG:0 nQG:1
 15 nS:0 nR:1 Q:0 nQ:1 QG:0 nQG:1
 16 nS:0 nR:1 Q:1 nQ:1 QG:1 nQG:1	nS = 0 -> Q = GG
 17 nS:0 nR:1 Q:1 nQ:0 QG:1 nQG:0
 20 nS:1 nR:1 Q:1 nQ:0 QG:1 nQG:0
 25 nS:0 nR:0 Q:1 nQ:0 QG:1 nQG:0	�����ċ֎~���́FnS = nR = 0 �ɐݒ�
 26 nS:0 nR:0 Q:1 nQ:1 QG:1 nQG:1
 30 nS:1 nR:0 Q:1 nQ:1 QG:1 nQG:1	nS = 1 �Ő�ɖ�����
 31 nS:1 nR:1 Q:0 nQ:1 QG:0 nQG:1	-> Q = 0 �Ƀ��Z�b�g
 35 nS:0 nR:0 Q:0 nQ:1 QG:0 nQG:1	�ēx�֎~���́FnS = nR = 0 �ɐݒ�
 36 nS:0 nR:0 Q:1 nQ:1 QG:1 nQG:1
 40 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1	�����ɉ����FnS = nR = 1 -> ���U
 41 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 42 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1
 43 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 44 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1
 45 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 46 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1
 47 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 48 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1
 49 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 50 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1
 51 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 52 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1
 53 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 54 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1
 55 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 *--------------------------------------------------------------------*/
