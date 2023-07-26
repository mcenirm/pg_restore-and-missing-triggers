CREATE FUNCTION public.update_updatetime()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updatetime = now();
    RETURN new;
END;
$$;

CREATE TABLE public.t1 (
    t1_text     text,
    updatetime  timestamp WITHOUT time zone DEFAULT now()
);

INSERT INTO public.t1 (t1_text) VALUES ('a');
INSERT INTO public.t1 (t1_text) VALUES ('b');
INSERT INTO public.t1 (t1_text) VALUES ('c');

CREATE TRIGGER update_t1_updatetime
    BEFORE UPDATE ON public.t1
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updatetime();
