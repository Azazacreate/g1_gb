
#define OP_NONE	 0
#define OP_PLUS  1
#define OP_MINUS 2
#define OP_MULT  3
#define OP_DIV   4


class CArith 
{ 
 public:

  void put_Accum(long l);
  long get_Accum(void);
  void put_Opnd(long l);
  long get_Opnd(void);
  void put_Op(long op);
  long get_Op(void);
  void put_Displ(long displ) ;
  long get_Displ(void) ;
  BOOL Eval(void);
  void Display(CWnd* w);
  void Quit(void);
  BOOL Button(LPCTSTR b,CWnd* w);

  BOOL ButtonPush(int button,CWnd* w);

  CArith()
  {
    m_op = m_opnd = m_accum = m_displ = 0 ;
	m_state = STATE_LOPND ;
  }

  enum states { STATE_LOPND, STATE_OP, STATE_ROPND, STATE_EVAL };

 private:
  long  m_op;
  long  m_opnd;
  long  m_accum;
  long  m_displ;
  enum states m_state;
};
