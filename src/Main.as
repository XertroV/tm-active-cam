void Main() {
    startnew(MainCoro);
}

auto carModelTy = Reflection::GetType("CGameItemModel");
auto carModelCamMember = carModelTy.GetMember("Cameras");

void MainCoro() {
    CGameItemModel@ car;
    while (true) {
        yield();
        try {
            @car = cast<CGameItemModel>(GetApp().GlobalCatalog.Chapters[1].Articles[0].LoadedNod);
        } catch {
            @car = null;
            trace(getExceptionInfo());
        }
        if (car is null || car.Cameras.Length < 3 || carModelCamMember.Offset > 65000) {
            _CurrentCamType = ActiveCam::CamTy::None;
            continue;
        }
        auto camsPtr = Dev::GetOffsetUint64(car, carModelCamMember.Offset);
        auto cam1Ptr = Dev::ReadUInt64(camsPtr);
        auto cam2Ptr = Dev::ReadUInt64(camsPtr + 8);
        auto cam3Ptr = Dev::ReadUInt64(camsPtr + 16);
        if (IsCamActive(cam1Ptr)) _CurrentCamType = ActiveCam::CamTy::Cam1;
        else if (IsCamActive(cam2Ptr)) _CurrentCamType = ActiveCam::CamTy::Cam2;
        else if (IsCamActive(cam3Ptr)) _CurrentCamType = ActiveCam::CamTy::Cam3;
        else if (IsAltCamActive(cam1Ptr, 656)) _CurrentCamType = ActiveCam::CamTy::Cam1Alt;
        else if (IsAltCamActive(cam2Ptr, -2064)) _CurrentCamType = ActiveCam::CamTy::Cam2Alt;
        else if (IsAltCamActive(cam3Ptr, 7408)) _CurrentCamType = ActiveCam::CamTy::Cam3Alt;
        else {
            // ! this incorrectly says freecam when alt cam offsets are wrong
            // warn("Unable to tell active cam but should be able to.");
            // _CurrentCamType = ActiveCam::CamTy::None;
            _CurrentCamType = ActiveCam::CamTy::FreeCam;
        }
    }
}

bool IsCamActive(uint64 ptr) {
    return Dev::ReadUInt8(ptr + 0x10) == 0x1c;
}
bool IsAltCamActive(uint64 ptr, int offset) {
    return Dev::ReadUInt8(ptr + offset) == 0x06;
}

ActiveCam::CamTy _CurrentCamType;

namespace ActiveCam {
    CamTy CurrentCamera() {
        return _CurrentCamType;
    }
    bool IsAlt(CamTy ty) {
        if (ty == 0) return false;
        return _CurrentCamType & 0x01 == 0;
    }
    bool IsCam1(CamTy ty) {
        if (ty == 0) return false;
        return (_CurrentCamType + 1) / 2 == 1;
    }
    bool IsCam2(CamTy ty) {
        if (ty == 0) return false;
        return (_CurrentCamType + 1) / 2 == 2;
    }
    bool IsCam3(CamTy ty) {
        if (ty == 0) return false;
        return (_CurrentCamType + 1) / 2 == 3;
    }

    // Returns an array of 2 elements: {CamNumber, IsAlt}. CamNumber is 1, 2, or 3; and IsAlt is 0 (false) or 1 (true)
    int[]@ AsTypeAndAlt(CamTy ty) {
        return {(_CurrentCamType + 1) / 2, _CurrentCamType & 0x01 ^ 1};
    }
}
