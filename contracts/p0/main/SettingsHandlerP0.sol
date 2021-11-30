// SPDX-License-Identifier: BlueOak-1.0.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "contracts/p0/libraries/Oracle.sol";
import "contracts/libraries/Fixed.sol";
import "contracts/p0/interfaces/IAsset.sol";
import "contracts/p0/interfaces/IFurnace.sol";
import "contracts/p0/interfaces/IMain.sol";
import "contracts/p0/interfaces/IRToken.sol";
import "contracts/p0/interfaces/IStRSR.sol";
import "contracts/p0/interfaces/IVault.sol";
import "contracts/p0/main/Mixin.sol";

/// Settings mixin for Main
contract SettingsHandlerP0 is Ownable, Mixin, ISettingsHandler {
    using Oracle for Oracle.Info;
    using FixLib for Fix;

    Oracle.Info private _oracle;

    uint256 private _rewardStart;
    uint256 private _rewardPeriod;
    uint256 private _auctionPeriod;
    uint256 private _stRSRWithdrawalDelay;
    uint256 private _defaultDelay;

    Fix private _maxTradeSlippage;
    Fix private _maxAuctionSize;
    Fix private _minRecapitalizationAuctionSize;
    Fix private _minRevenueAuctionSize;
    Fix private _migrationChunk;
    Fix private _issuanceRate;
    Fix private _defaultThreshold;

    IStRSR private _stRSR;
    IFurnace private _furnace;

    IAsset private _rTokenAsset;
    IAsset private _rsrAsset;
    IAsset private _compAsset;
    IAsset private _aaveAsset;

    function init(ConstructorArgs calldata args) public virtual override {
        super.init(args);
        _oracle = args.oracle;

        _rewardStart = args.config.rewardStart;
        _rewardPeriod = args.config.rewardPeriod;
        _auctionPeriod = args.config.auctionPeriod;
        _stRSRWithdrawalDelay = args.config.stRSRWithdrawalDelay;
        _defaultDelay = args.config.defaultDelay;

        _maxTradeSlippage = args.config.maxTradeSlippage;
        _maxAuctionSize = args.config.maxAuctionSize;
        _minRecapitalizationAuctionSize = args.config.minRecapitalizationAuctionSize;
        _minRevenueAuctionSize = args.config.minRevenueAuctionSize;
        _migrationChunk = args.config.migrationChunk;
        _issuanceRate = args.config.issuanceRate;
        _defaultThreshold = args.config.defaultThreshold;
    }

    function setOracle(Oracle.Info memory oracle_) external override onlyOwner {
        _oracle = oracle_;
    }

    function oracle() public view override returns (Oracle.Info memory) {
        return _oracle;
    }

    function setStRSR(IStRSR stRSR_) external override onlyOwner {
        _stRSR = stRSR_;
    }

    function stRSR() public view override returns (IStRSR) {
        return _stRSR;
    }

    function setFurnace(IFurnace furnace_) external override onlyOwner {
        _furnace = furnace_;
    }

    function furnace() public view override returns (IFurnace) {
        return _furnace;
    }

    function setRTokenAsset(IAsset rTokenAsset_) external override onlyOwner {
        _rTokenAsset = rTokenAsset_;
    }

    function rTokenAsset() public view override returns (IAsset) {
        return _rTokenAsset;
    }

    function setRSRAsset(IAsset rsrAsset_) external override onlyOwner {
        _rsrAsset = rsrAsset_;
    }

    function rsrAsset() public view override returns (IAsset) {
        return _rsrAsset;
    }

    function setCompAsset(IAsset compAsset_) external override onlyOwner {
        _compAsset = compAsset_;
    }

    function compAsset() public view override returns (IAsset) {
        return _compAsset;
    }

    function setAaveAsset(IAsset aaveAsset_) external override onlyOwner {
        _aaveAsset = aaveAsset_;
    }

    function aaveAsset() public view override returns (IAsset) {
        return _aaveAsset;
    }

    function setRewardStart(uint256 rewardStart_) external override onlyOwner {
        _rewardStart = rewardStart_;
    }

    function rewardStart() public view override returns (uint256) {
        return _rewardStart;
    }

    function setRewardPeriod(uint256 rewardPeriod_) external override onlyOwner {
        _rewardPeriod = rewardPeriod_;
    }

    function rewardPeriod() public view override returns (uint256) {
        return _rewardPeriod;
    }

    function setAuctionPeriod(uint256 auctionPeriod_) external override onlyOwner {
        _auctionPeriod = auctionPeriod_;
    }

    function auctionPeriod() public view override returns (uint256) {
        return _auctionPeriod;
    }

    function setStRSRWithdrawalDelay(uint256 stRSRWithdrawalDelay_) external override onlyOwner {
        _stRSRWithdrawalDelay = stRSRWithdrawalDelay_;
    }

    function stRSRWithdrawalDelay() public view override returns (uint256) {
        return _stRSRWithdrawalDelay;
    }

    function setDefaultDelay(uint256 defaultDelay_) external override onlyOwner {
        _defaultDelay = defaultDelay_;
    }

    function defaultDelay() public view override returns (uint256) {
        return _defaultDelay;
    }

    function setMaxTradeSlippage(Fix maxTradeSlippage_) external override onlyOwner {
        _maxTradeSlippage = maxTradeSlippage_;
    }

    function maxTradeSlippage() public view override returns (Fix) {
        return _maxTradeSlippage;
    }

    function setMaxAuctionSize(Fix maxAuctionSize_) external override onlyOwner {
        _maxAuctionSize = maxAuctionSize_;
    }

    function maxAuctionSize() public view override returns (Fix) {
        return _maxAuctionSize;
    }

    function setMinRecapitalizationAuctionSize(Fix minRecapitalizationAuctionSize_) external override onlyOwner {
        _minRecapitalizationAuctionSize = minRecapitalizationAuctionSize_;
    }

    function minRecapitalizationAuctionSize() public view override returns (Fix) {
        return _minRecapitalizationAuctionSize;
    }

    function setMinRevenueAuctionSize(Fix minRevenueAuctionSize_) external override onlyOwner {
        _minRevenueAuctionSize = minRevenueAuctionSize_;
    }

    function minRevenueAuctionSize() public view override returns (Fix) {
        return _minRevenueAuctionSize;
    }

    function setMigrationChunk(Fix migrationChunk_) external override onlyOwner {
        _migrationChunk = migrationChunk_;
    }

    function migrationChunk() public view override returns (Fix) {
        return _migrationChunk;
    }

    function setIssuanceRate(Fix issuanceRate_) external override onlyOwner {
        _issuanceRate = issuanceRate_;
    }

    function issuanceRate() public view override returns (Fix) {
        return _issuanceRate;
    }

    function setDefaultThreshold(Fix defaultThreshold_) external override onlyOwner {
        _defaultThreshold = defaultThreshold_;
    }

    function defaultThreshold() public view override returns (Fix) {
        return _defaultThreshold;
    }

    // Useful view functions for reading portions of the state
    /// @return The RToken deployment
    function rToken() public view override returns (IRToken) {
        return IRToken(address(_rTokenAsset.erc20()));
    }

    /// @return The RSR deployment
    function rsr() public view override returns (IERC20) {
        return _rsrAsset.erc20();
    }
}
