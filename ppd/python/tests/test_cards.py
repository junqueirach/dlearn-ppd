from ppd.cards import fmt_int, fmt_real, parse_ints, parse_reals


def test_int_field():
    assert fmt_int(1) == "    1"
    assert fmt_int(-12) == "  -12"
    assert fmt_int(None) == "     "


def test_real_field_fits_and_round_trips():
    for x in (0.0, 1.0, -1000.0, 600.0, 0.023, 0.3025, 7.3e-6, 2.1e5, 3e7, -0.1, 1 / 3, 123456789.0):
        s = fmt_real(x)
        assert len(s) == 10
        back = parse_reals(s, 1, 1)[0]
        assert abs(back - x) <= 1e-6 * max(1.0, abs(x))


def test_parse_blank_is_zero():
    assert parse_ints("    1         3", 3) == [1, 0, 3]
    assert parse_reals("          ", 1, 1) == [0.0]
    assert parse_reals("     1.5D0", 1, 1) == [1.5]
