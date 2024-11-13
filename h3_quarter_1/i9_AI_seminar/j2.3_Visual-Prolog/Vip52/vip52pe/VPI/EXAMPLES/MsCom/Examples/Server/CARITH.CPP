#include "stdafx.h"
#include "mycalc3.h"
#include "myDlg.h"
#include "DlgProxy.h"

//---------------------------------------------------------------------
//                       Arithmetic features
//---------------------------------------------------------------------



void
CArith::put_Accum(long l)
{
    m_accum = l;
}


long
CArith::get_Accum()
{
    return m_accum;
}


void
CArith::put_Opnd(long l)
{
    m_opnd = l;
}


long
CArith::get_Opnd()
{
    return m_opnd;
}


void
CArith::put_Op(long op)
{
    m_op = op;
}


long
CArith::get_Op()
{
    return m_op;
}

void
CArith::put_Displ(long displ)
{
    m_displ = displ;
}


long
CArith::get_Displ()
{
    return m_displ;
}


BOOL
CArith::Eval()
{
    if(m_op == OP_NONE)
      return FALSE;

    switch(m_op){
    case OP_PLUS:
      m_accum += m_opnd;
      break;
    case OP_MINUS:
      m_accum -= m_opnd;
      break;
    case OP_MULT:
      m_accum *= m_opnd;
      break;
    case OP_DIV:
      m_accum = (m_opnd == 0) ? 0 : (m_accum / m_opnd);
      break;
    default:
      // ASSERT(UNREACHED);
      return FALSE;

    }

    m_state = STATE_EVAL;

    return TRUE;
}


//---------------------------------------------------------------------
//                       User Interface features
//---------------------------------------------------------------------


/***
*void CArith::Display()
*Purpose:
*  Display the contents of the register currently being edited.
*
*Entry:
*  None
*
*Exit:
*  None
*
***********************************************************************/
void
CArith::Display( CWnd* w )
{
	char outs[80] ;
	long* v = (m_state == STATE_ROPND) ? &m_opnd : &m_accum;

	wsprintf(outs,"%ld",m_displ=(*v)) ;
    w->SetDlgItemText(IDC_DISPLAY,outs) ;
}


BOOL
CArith::Button( LPCTSTR b, CWnd* w )
{
    int i, button;

static struct {
    CHAR ch;
    int idc;
} NEAR rgIdcOfCh[] = {
      { '+', IDC_PLUS   }
    , { '-', IDC_MINUS  }
    , { '*', IDC_MULT   }
    , { '/', IDC_DIV    }
    , { 'C', IDC_CLEAR  }
    , { 'c', IDC_CLEAR  }
    , { '=', IDC_EQUALS }
    , { '0', IDC_ZERO   }
    , { '1', IDC_ONE    }
    , { '2', IDC_TWO    }
    , { '3', IDC_THREE  }
    , { '4', IDC_FOUR   }
    , { '5', IDC_FIVE   }
    , { '6', IDC_SIX    }
    , { '7', IDC_SEVEN  }
    , { '8', IDC_EIGHT  }
    , { '9', IDC_NINE   }
    , { -1 , -1         }
};
    
      // translate button string into control ID
      for(i = 0;; ++i){
        if(rgIdcOfCh[i].ch == -1)
          return FALSE;
        if(rgIdcOfCh[i].ch == b[0]){
          button = rgIdcOfCh[i].idc;
          break;
        }
      }
      
      if (!ButtonPush(button,w))
        return FALSE;

    

    return TRUE;        // success

}


BOOL
CArith::ButtonPush(int button,CWnd* w)
{
	
    if(button >= IDC_ZERO && button <= IDC_NINE){

      long lVal = button - IDC_ZERO;

      switch(m_state){
      case STATE_EVAL:
        m_accum = lVal;
        m_state = STATE_LOPND;
        break;
      case STATE_OP:
        m_opnd = lVal;
        m_state = STATE_ROPND;
        break;
      case STATE_LOPND:
        m_accum = (m_accum * 10) + lVal;
        break;
      case STATE_ROPND:
        m_opnd  = (m_opnd * 10) + lVal;
        break;
      }

    }else if(button >= IDC_PLUS && button <= IDC_DIV){

      if(m_state == STATE_ROPND)
        Eval();

      m_opnd  = m_accum;
      m_state = STATE_OP;
      m_op    = button - IDC_PLUS + OP_PLUS ;

    }else if(button == IDC_EQUALS){

      if(m_state > STATE_LOPND)
        Eval();

    }else if (button == IDC_CLEAR){
      long* lop = (m_state == STATE_ROPND) ? &m_opnd : &m_accum;
      *lop = m_displ = 0 ;
      w->SetDlgItemText(IDC_DISPLAY,"0") ;		
	  return TRUE ;
    } else {

      return 0; // unknown button

    }

    // Update the calculator display

    Display(w);

    return TRUE;
}

/***
*void CArith::Quit()
*Purpose:
*
*Entry:
*  None
*
*Exit:
*  None
*
***********************************************************************/
void
CArith::Quit()
{

    PostQuitMessage(0);

}

