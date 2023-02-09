namespace ActiveCam {
    import CamTy CurrentCamera() from "ActiveCam";
    import bool IsAlt(CamTy ty) from "ActiveCam";
    import bool IsCam1(CamTy ty) from "ActiveCam";
    import bool IsCam2(CamTy ty) from "ActiveCam";
    import bool IsCam3(CamTy ty) from "ActiveCam";

    // Returns an array of 2 elements: {CamNumber, IsAlt}. CamNumber is 1, 2, or 3; and IsAlt is 0 (false) or 1 (true)
    import int[]@ AsTypeAndAlt(CamTy ty) from "ActiveCam";
}
