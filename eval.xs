#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

int init_done = 0;

#if 0
#define EVIL_EVAL_DEBUG(x) x
#else
#define EVIL_EVAL_DEBUG(x)
#endif

OP* (*real_pp_eval)(pTHX);
PP(pp_evil_eval) { 
    dSP; dTARG;
    SV* hook;
    SV* sv;
    HV* saved_hh = NULL;
    I32 count, c, ax;

    hook = Perl_refcounted_he_fetch( PL_curcop->cop_hints_hash, Nullsv, "overload::eval", 14, 0, 0);
    if ( ! SvPOK( hook ) ) {
        return real_pp_eval(aTHX);
    }

    /* Take the source off the argument stack. */
    if (PL_op->op_private & OPpEVAL_HAS_HH) {
        saved_hh = (HV*) SvREFCNT_inc(POPs);
    }
    sv = POPs;

    ENTER;
    SAVETMPS;
    PUSHMARK(SP);
    XPUSHs(sv);
    PUTBACK;

    count = call_sv( hook, GIMME_V );
    SPAGAIN;
    SP -= count;
    ax = (SP - PL_stack_base) + 1;
    for ( c = 0; c < count; ++c ) {
        SvREFCNT_inc( ST(c) );
    }

    FREETMPS;
    LEAVE;

    EXTEND(SP,count);
    for ( c = 0; c < count; ++c ) {
        PUSHs(ST(c));
    }

    RETURN;
}

MODULE = overload::eval	PACKAGE = overload::eval PREFIX = evil_eval_

PROTOTYPES: ENABLE

BOOT:
if ( ! init_done++  ) {
    /* Is this a race in threaded perl? */
    real_pp_eval = PL_ppaddr[OP_ENTEREVAL];
    PL_ppaddr[OP_ENTEREVAL] = Perl_pp_evil_eval;
}